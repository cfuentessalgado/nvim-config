local ns_name = 'php-auto-test'
local ns = vim.api.nvim_create_namespace(ns_name)
local group = vim.api.nvim_create_augroup('php-automagic', { clear = true })

local find_test_line = function(bufnr, entry)
    if entry.exceptionLine then
        return tonumber(entry.exceptionLine) - 1
    end
    local result = -1
    vim.api.nvim_buf_call(bufnr, function()
        result = vim.fn.search(entry.methodName)
    end)
    return result - 1
end

local make_key = function(entry)
    assert(entry.className, "Must have class: " .. vim.inspect(entry))
    assert(entry.methodName, "Must have test: " .. vim.inspect(entry))
    return string.format("%s/%s", entry.className, entry.methodName)
end

local add_test = function(state, entry)
    local key = make_key(entry)
    state.tests[key] = {
        name = entry.methodName,
        line = find_test_line(state.bufnr, entry),
        status = tonumber(entry.status),
        output = {}
    }
end

local attach_to_buffer = function(bufnr, command)
    local state = {
        bufnr = bufnr,
        tests = {},
    }
    local append_output = function(_, data)
        if not data then
            return
        end
        for _, output in ipairs(data) do
            if output:len() > 2 then
                output = output:gsub("@", "") .. "\n"
                local decoded = vim.json.decode(output)
                for _, test in ipairs(decoded.tests.test) do
                    if tonumber(test.status) == 0 then
                        local text = { '✔' }
                        local line = find_test_line(bufnr, test)
                        vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                            virt_text = { text }
                        })
                    end
                    add_test(state, test)
                    -- vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {test.className})
                    -- set_tests_state(state)
                end
            end
        end
    end
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        pattern = "*.php",
        callback = function()
            -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "hello", "world2" })
            local after_test = function()
                vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
                local cat_command = { "xq", "-c", ".", "/tmp/" .. ns_name }
                vim.fn.jobstart(cat_command, {
                    stdout_buffered = true,
                    on_stdout = append_output,
                    on_exit = function()
                        local failed = {}
                        for _, test in pairs(state.tests) do
                            if test.line then
                                if test.status > 0 then
                                    table.insert(failed, {
                                        bufnr = bufnr,
                                        lnum = test.line,
                                        col = 0,
                                        severity = vim.diagnostic.severity.ERROR,
                                        source = "phpunit",
                                        message = "Test failed",
                                        user_data = {},
                                    })
                                end
                            end
                        end
                        vim.diagnostic.set(ns, bufnr, failed, {})
                    end
                })
            end
            vim.fn.jobstart(command, {
                stdout_buffered = true,
                on_exit = after_test,
            })
        end
    })
end

-- attach_to_buffer(84, "*Test.php", { "vendor/bin/phpunit", "--testdox-xml=/tmp/nvim_test", })

vim.api.nvim_create_user_command("PhpTestOnSave", function()
    local buffer = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buffer)
    local filename = string.gsub(file, "(.*/)(.*)", "%2"):gsub('.php', '')
    attach_to_buffer(buffer, { "vendor/bin/phpunit", "--testdox-xml=/tmp/" .. ns_name, "--filter=" .. filename })
end, {})

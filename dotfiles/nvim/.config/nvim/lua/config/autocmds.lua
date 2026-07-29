local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local yank_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = yank_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

local lastpos_group = augroup("RestoreLastPos", { clear = true })
autocmd("BufReadPost", {
    group = lastpos_group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

local filetypes_group = augroup("FiletypeSettings", { clear = true })
autocmd("Filetype", {
    group = filetypes_group,
    pattern = { "lua", "vim", "sh", "bash" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

local external_changes_group = augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = external_changes_group,
    command = "checktime",
})

autocmd("FileChangedShellPost", {
    group = external_changes_group,
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
    end,
})

local highlight_yank_group = augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
    group = highlight_yank_group,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

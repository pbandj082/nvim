local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = augroup("user_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("BufReadPost", {
  group = augroup("user_restore_cursor", { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.diagnostic.config({
  float = { border = "rounded" },
  severity_sort = true,
})


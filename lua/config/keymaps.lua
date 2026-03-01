local map = vim.keymap.set

-- Telescope
map("n", "<C-p>", function()
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files, { show_untracked = true })
  if not ok then
    builtin.find_files()
  end
end, { desc = "Go to file" })

map("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Buffers" })

map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "Help tags" })

-- Oil
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Explorer (tree)
map("n", "<leader>e", "<CMD>Neotree toggle reveal<CR>", { desc = "Explorer" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Line diagnostics" })

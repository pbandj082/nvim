local map = vim.keymap.set

local function diagnostic_jump(count)
  if vim.diagnostic.jump then
    vim.diagnostic.jump({ count = count })
    return
  end

  if count > 0 then
    ---@diagnostic disable-next-line: deprecated
    vim.diagnostic.goto_next()
  else
    ---@diagnostic disable-next-line: deprecated
    vim.diagnostic.goto_prev()
  end
end

local function diagnostic_open_float(opts)
  local ok = pcall(vim.diagnostic.open_float, opts)
  if ok then
    return
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.diagnostic.open_float(0, opts)
end

-- Telescope
map("n", "<C-p>", function()
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files, { show_untracked = true })
  if not ok then
    builtin.find_files({ hidden = true })
  end
end, { desc = "Go to file" })

map("n", "<leader>ff", function()
  require("telescope.builtin").find_files({ hidden = true })
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
map("n", "[d", function()
  diagnostic_jump(-1)
end, { desc = "Prev diagnostic" })
map("n", "]d", function()
  diagnostic_jump(1)
end, { desc = "Next diagnostic" })
map("n", "<leader>dd", function()
  diagnostic_open_float({ scope = "cursor", border = "rounded", source = true })
end, { desc = "Diagnostics (cursor)" })
map("n", "<leader>dl", function()
  diagnostic_open_float({ scope = "line", border = "rounded", source = true })
end, { desc = "Diagnostics (line)" })
map("n", "<leader>db", function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Diagnostics (buffer list)" })
map("n", "<leader>dq", function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics (workspace list)" })

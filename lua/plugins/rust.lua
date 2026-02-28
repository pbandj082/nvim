return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
              if vim.lsp and vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              elseif vim.lsp and vim.lsp.buf and vim.lsp.buf.inlay_hint then
                pcall(vim.lsp.buf.inlay_hint, bufnr, true)
              end
            end
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              check = {
                command = "clippy",
              },
            },
          },
        },
      }
    end,
  },
}

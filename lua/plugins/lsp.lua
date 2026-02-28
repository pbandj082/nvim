return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
      },
    },
    config = function(_, opts)
      local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not ok_mason_lspconfig then
        vim.notify("missing plugin: mason-lspconfig.nvim", vim.log.levels.WARN)
        return
      end

      local capabilities = {}
      if vim.lsp and vim.lsp.protocol and vim.lsp.protocol.make_client_capabilities then
        capabilities = vim.lsp.protocol.make_client_capabilities()
      end
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- mason-lspconfig.nvim v2 removed `.setup_handlers()` in favor of Neovim's native
      -- `vim.lsp.config()` + `vim.lsp.enable()` APIs.
      if mason_lspconfig.setup_handlers then
        mason_lspconfig.setup(opts)

        local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
        if not ok_lspconfig then
          vim.notify("missing plugin: nvim-lspconfig", vim.log.levels.WARN)
          return
        end
        mason_lspconfig.setup_handlers({
          function(server_name)
            if server_name == "rust_analyzer" then
              return
            end
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
            })
          end,
        })
        return
      end

      if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then
        vim.notify("mason-lspconfig.nvim requires Neovim 0.11+ (vim.lsp.config)", vim.log.levels.WARN)
        return
      end

      local function config_server(server_name, config)
        if server_name == "rust_analyzer" then
          return
        end
        config = config or {}
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(server_name, config)
      end

      config_server("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      local servers = {}
      for _, server_name in ipairs(opts.ensure_installed or {}) do
        local normalized = server_name:match("^[^@]+") or server_name
        servers[normalized] = true
      end
      if mason_lspconfig.get_installed_servers then
        for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
          servers[server_name] = true
        end
      end
      servers.lua_ls = nil
      servers.rust_analyzer = nil
      for server_name in pairs(servers) do
        config_server(server_name, {})
      end

      if opts.automatic_enable == nil or opts.automatic_enable == true then
        opts.automatic_enable = { exclude = { "rust_analyzer" } }
      elseif type(opts.automatic_enable) == "table" and type(opts.automatic_enable.exclude) == "table" then
        local has_rust_analyzer = false
        for _, server_name in ipairs(opts.automatic_enable.exclude) do
          if server_name == "rust_analyzer" then
            has_rust_analyzer = true
            break
          end
        end
        if not has_rust_analyzer then
          table.insert(opts.automatic_enable.exclude, "rust_analyzer")
        end
      end

      mason_lspconfig.setup(opts)
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}

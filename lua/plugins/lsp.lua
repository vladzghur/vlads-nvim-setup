vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mrcjkb/rustaceanvim',
  'https://github.com/nvim-flutter/flutter-tools.nvim',
  'https://github.com/nvim-lua/plenary.nvim', -- dependency of flutter-tools
  'https://github.com/saecki/crates.nvim',    -- Cargo.toml help
  'https://github.com/folke/lazydev.nvim',    -- lua_ls knows about vim.*
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range('1.*'),       -- prebuilt binary, no Rust build needed
  },
  'https://github.com/mikavilpas/blink-ripgrep.nvim',
  'https://github.com/b0o/SchemaStore.nvim', -- json 
  'https://github.com/rafamadriz/friendly-snippets',
})

vim.lsp.document_color.enable(true)

---------------------------------------------------------------------------
-- Completion (blink.cmp)
---------------------------------------------------------------------------
require("blink.cmp").setup({
  keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> select, <C-space> open, <C-e> close
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      ripgrep = {
        module = "blink-ripgrep",
        name = "Ripgrep",
        -- see the full configuration below for all available options
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {},
      },
    },
  },
  cmdline = {
    keymap = { preset = "inherit" },
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- applies to every server started via nvim-lspconfig / mason-lspconfig
vim.lsp.config("*", { capabilities = capabilities })

---------------------------------------------------------------------------
-- Mason + servers
---------------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "clangd",
  },
  automatic_enable = {
    exclude = {
      "rust_analyzer", -- handled by rustaceanvim
    },
  },
})

require("lazydev").setup({})

---------------------------------------------------------------------------
-- Rust
---------------------------------------------------------------------------
vim.g.rustaceanvim = {
  server = {
    capabilities = capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
      },
    },
  },
}

require("crates").setup({
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
})

---------------------------------------------------------------------------
-- Flutter / Dart
---------------------------------------------------------------------------
require("flutter-tools").setup({
  lsp = { capabilities = capabilities },
})

---------------------------------------------------------------------------
-- Keymaps (on top of the 0.11+ defaults: grn, gra, grr, gri, gO, K)
---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
    map("<leader>o", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, "Organize imports")
  end,
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.enable("jsonls")

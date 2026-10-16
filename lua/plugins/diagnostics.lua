vim.pack.add({
  'https://github.com/rachartier/tiny-code-action.nvim',
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
  'https://github.com/stevearc/quicker.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/artemave/workspace-diagnostics.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
})

require("tiny-code-action").setup({})
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = 'Code actions'})

require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })

require("quicker").setup()

require("fidget").setup {
}

vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    -- some clients support workspace diagnostics natively
    if client:supports_method("workspace/diagnostic", bufnr) then
      vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
    else
      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end
  end
})

require('gitsigns').setup()

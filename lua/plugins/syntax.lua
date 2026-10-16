vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/wansmer/treesj',
  'https://github.com/abecodes/tabout.nvim',
})

require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require('nvim-treesitter').install { 'rust', 'dart', 'lua', 'cpp', }

require('mini.ai').setup() -- aroind (a) and inside (i) keymaps
require('mini.pairs').setup() -- automatically creates pairs for symbols like (), [], etc.
require('mini.surround').setup() -- access to surround keymaps sa, sd, sc, etc.
require('mini.jump').setup() -- f, t, F and T work on multiple lines
-- better dev icons
require('mini.icons').setup() 
MiniIcons.mock_nvim_web_devicons()

-- Splits and jons lines
require('treesj').setup() -- <space>m - toggle, <space>j - join, <space>s - split

require('tabout').setup() -- Tabs out of parentheses, quotes, etc. in insert mode

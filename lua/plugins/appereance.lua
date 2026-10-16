vim.pack.add({
  'https://github.com/sainnhe/everforest',
  "https://github.com/sphamba/smear-cursor.nvim",
  'https://github.com/nvim-lua/plenary.nvim', -- dependency for todo and telescope
  "https://github.com/nvim-tree/nvim-web-devicons",
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/m4xshen/smartcolumn.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/mawkler/modicator.nvim', -- changes line number color
})

vim.g.everforest_enable_italic = true
vim.g.everforest_background = 'hard'
vim.g.everforest_transparent_background = 2 
-- ^^^ Options: 0 (disabled), 1 (normal text bg), 2 (statusline/borders included)

vim.cmd("colorscheme everforest")

require('smear_cursor').setup({
  -- Your option
})

require("todo-comments").setup({})

require("smartcolumn").setup({
  colorcolumn = '100'
})

require('lualine').setup({
  options = {
    theme = 'auto', -- or your favorite theme

    -- Using the dither symbols as section separators
    -- section_separators = { right = '░▒▓', left = '▓▒░' },

    section_separators = { right = '', left = '' },

    -- Optional: You can also use a single dither block for components
    component_separators = { right = '', left = '' },

    globalstatus = true,
  },
})

require('modicator').setup()


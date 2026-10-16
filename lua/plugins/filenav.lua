vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/refractalize/oil-git-status.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',  -- better prompt ui
  'https://github.com/nvim-telescope/telescope-frecency.nvim',  
  'https://github.com/kevinhwang91/nvim-hlslens', -- additional info in word search
  'https://github.com/jake-stewart/multicursor.nvim',
  'https://github.com/akinsho/toggleterm.nvim',
})

require("oil").setup({
  columns = {
    "icon",
    "git_status",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  win_options = {
    signcolumn = "yes:2",
  },
})
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open Oil" })
require('oil-git-status').setup({
})

require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
require("telescope").load_extension("frecency")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('hlslens').setup()
local kopts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', 'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  {
    desc ="Next search result",
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

local mc = require("multicursor-nvim")
mc.setup()

local set = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)

-- -- Add or skip adding a new cursor by matching word/selection
set({"n", "x"}, "<leader>in", function() mc.matchAddCursor(1) end)
set({"n", "x"}, "<leader>is", function() mc.matchSkipCursor(1) end)
set({"n", "x"}, "<leader>iN", function() mc.matchAddCursor(-1) end)
set({"n", "x"}, "<leader>iS", function() mc.matchSkipCursor(-1) end)

-- Add and remove cursors with control + left click.
set("n", "<c-leftmouse>", mc.handleMouse)
set("n", "<c-leftdrag>", mc.handleMouseDrag)
set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Disable and enable cursors.
set({"n", "x"}, "<c-q>", mc.toggleCursor)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)

    -- Select a different cursor as the main one.
    layerSet({"n", "x"}, "<left>", mc.prevCursor)
    layerSet({"n", "x"}, "<right>", mc.nextCursor)

    -- Delete the main cursor.
    layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

    -- Enable and clear cursors using escape.
    layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
end)

require("toggleterm").setup({
  open_mapping = [[<leader>tt]],   -- toggle the last terminal (works in normal, insert, and terminal mode)
  insert_mappings = true,
  terminal_mappings = true,
  direction = "horizontal",   -- default: bottom
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  winbar = { enabled = true }, -- shows a name/number per terminal (experimental)
})

-- choose the side explicitly
vim.keymap.set("n", "<leader>tb", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal (bottom)" })
vim.keymap.set("n", "<leader>tr", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal (right)" })

-- multiple terminals
vim.keymap.set("n", "<leader>tn", "<cmd>TermNew<CR>", { desc = "New terminal" })
vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "Select terminal" })

-- easier navigation out of a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm#*",
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("n", "<leader>tk", "<cmd>bdelete!<CR>", { buffer = 0, desc = "Kill terminal" })
  end,
})

vim.api.nvim_set_keymap('n', '<Space>', '', {})
vim.g.mapleader = " "                               -- Set mapleader before anything else

require('plugins')
require('keymap')
require('lsp_config')
require('utils')

-- settings: general case, use vim.opt. specific case, use vim.o|vim.bo|vim.wo
vim.o.expandtab = true                            -- Use spaces instead of tabs
vim.o.hidden = true                               -- Enable Background buffers instead of unloading them
vim.o.tabstop = 2                                 -- Number of spaces
vim.o.softtabstop = 2                             -- Similar to tabstop
vim.o.shiftwidth = 2                              -- Size of indent
vim.o.shiftround = true                           -- Round indent
vim.o.smartindent = true                          -- Auto indent
vim.o.number = true                               -- Show line numbers
vim.o.relativenumber = true                       -- Show relative line nums
vim.o.wrap = false                                -- Disable line wrapping
vim.o.list = true                                 -- Show invis charas
vim.opt.listchars = {                               -- these list chars
    tab      = '»·',
    eol      = '↵',
    nbsp     = '␣',
    extends  = '…',
    precedes = '…',
    trail    = '·',
}
vim.o.splitbelow = true                           -- Default splitting behavior
vim.o.splitright = true                           -- Default splitting behavior
vim.o.laststatus = 2                              -- Always show status
vim.opt.wildmode = {"list", "longest"}              -- Command-line completion mode
vim.o.termguicolors = true                        -- True color cupport
vim.o.ignorecase = true                           -- Ignore case
vim.o.smartcase = true                            -- If upper case in search, do not ignore
vim.o.swapfile = false                            -- Do not create swapfile for new buffers
vim.o.backup = false                              -- Do not create backup files
vim.o.undodir = "/home/kuity/.vim/undodir"        -- Set undodir
vim.o.undofile = true                             -- Enable undofile
vim.o.mouse = "a"                                 -- Enable mouse support
vim.o.cursorline = true                           -- Highlight cursor line
vim.o.belloff = "all"                             -- Do not ring the bell
vim.o.hlsearch = false                            -- search behavior
vim.o.incsearch = true                            -- search behavior
vim.o.foldmethod = 'expr'                         -- fold method
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'     -- fold expr

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

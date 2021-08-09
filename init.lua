vim.api.nvim_set_keymap('n', '<Space>', '', {})
vim.g.mapleader = " " -- Set mapleader before anything else
require('plugins')
require('keymap')
require('lsp_config')
require('utils')
require('settings')

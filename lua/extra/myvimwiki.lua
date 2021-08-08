vim.g.vimwiki_list = {{
  ext = ".md",
  path = "/home/kuity/projects/wiki/",
  syntax = "markdown"
}}

vim.g.vimwiki_ext2syntax = {
  [".markdown"] = "markdown",
  [".md"] = "markdown",
  [".mdown"] = "markdown"
}

vim.g.vimwiki_markdown_link_ext = 1   -- Makes vimwiki markdown links as [text](text.md) instead of [text](text)
vim.g.vimwiki_folding = 'custom'
vim.g.vimwiki_key_mappings = { ['lists'] = 0 }

vim.api.nvim_exec([[
  augroup Vimwiki
    autocmd!
    autocmd FileType vimwiki setlocal syntax=markdown
    autocmd FileType vimwiki setlocal foldenable
  augroup END
]], false)

-- specific mappings
vim.api.nvim_set_keymap('n', '<Leader><CR>', '<Plug>VimwikiFollowLink', {silent=true})
vim.api.nvim_set_keymap('n', '<Leader><Backspace>', '<Plug>VimwikiGoBackLink', {silent=true})
vim.api.nvim_set_keymap('n', 'gn', '<Plug>VimwikiNextLink', {silent=true})
vim.api.nvim_set_keymap('n', 'gp', '<Plug>VimwikiPrevLink', {silent=true})


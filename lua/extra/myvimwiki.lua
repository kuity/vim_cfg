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
vim.g.vimwiki_key_mappings = { ['lists'] = 0, ['links'] = 0 }

vim.api.nvim_exec([[
  augroup Vimwiki
    autocmd!
    autocmd FileType vimwiki setlocal syntax=markdown
    autocmd FileType vimwiki setlocal foldenable
    autocmd FileType vimwiki nmap <buffer> <Leader><CR> <Plug>VimwikiFollowLink
    autocmd FileType vimwiki nmap <buffer> <Leader><Backspace> <Plug>VimwikiGoBackLink
    autocmd FileType vimwiki nmap <buffer> gn <Plug>VimwikiNextLink
    autocmd FileType vimwiki nmap <buffer> gp <Plug>VimwikiPrevLink
    autocmd FileType vimwiki nmap <buffer> <Leader>w<Leader>i <Plug>VimwikiDiaryGenerateLinks
  augroup END
]], false)


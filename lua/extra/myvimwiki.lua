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
vim.g.taskwiki_markup_syntax = 'markdown'
vim.g.markdown_folding = 'expr'

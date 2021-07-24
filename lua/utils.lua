local M = {}

function M.reload_cfg()
  vim.cmd "source ~/.config/nvim/init.lua"
  vim.cmd "source ~/.config/nvim/lua/plugins.lua"
  vim.cmd "source ~/.config/nvim/lua/keymap.lua"
  vim.cmd "source ~/.config/nvim/lua/lsp_config.lua"
  vim.cmd "PackerCompile" -- Update plugin config
  vim.cmd "PackerSync" -- Clean, Install, Update
end

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
endfunction
]]
return M

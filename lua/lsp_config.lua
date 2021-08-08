local lspconfig = require('lspconfig')
local trouble = require('trouble')
local compe = require('compe')
local lspsaga = require('lspsaga')
local LSP_PATH = ""
local my_os = ""
USER = vim.fn.expand('$USER')
if vim.fn.has("mac") == 1 then
  LSP_PATH = "/Users/" .. USER .. "/.local/share/nvim/lspinstall/"
  my_os = "MacOS"
elseif vim.fn.has("unix") == 1 then
  LSP_PATH = "/home/" .. USER .. "/.local/share/nvim/lspinstall/"
  my_os = "Linux"
else
  print("LSP not supported")
end

local mapper = function(mode, key, result, opts)
  vim.api.nvim_buf_set_keymap(0, mode, key, result, opts)
end

local custom_attach = function(client, bufnr)
  -- Only autocomplete in lsp
  compe.setup({
    enabled = true,
    preselect = 'disable',
    source = {
      -- Passing a dict enables the completion source
      -- Menu is sorted by priority highest -> lowest
      vsnip     = {priority = 100},
      nvim_lsp    = {priority = 90},
      nvim_treesitter = {priority = 86},
      nvim_lua    = {priority = 85},
      buffer      = {priority = 80},
      path      = {priority = 70},
    },
  }, 0) -- Only current buffer

  -- Compe mappings
  mapper("i", "<C-o>", "compe#complete()", {silent = true, expr = true, noremap = true})
  mapper("i", "<C-y>", "compe#confirm()", {silent = true, expr = true, noremap = true})
  mapper("i", "<C-e>", "compe#close()", {silent = true, expr = true, noremap = true})
  mapper("i",  "<C-f>", "compe#scroll({ 'delta': +4 })", {silent = true, expr = true, noremap = true})
  mapper("i",  "<C-d>", "compe#scroll({ 'delta': -4 })", {silent = true, expr = true, noremap = true})

  -- lsp native mappings
  mapper("n",  "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", {silent = true, noremap = true})
  mapper("n",  "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", {silent = true, noremap = true})
  mapper("n",  "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", {silent = true, noremap = true})
  mapper("n",  "<Leader>af", "<cmd>lua vim.lsp.buf.formatting()<CR>", {silent = true, noremap = true})

  -- Lspsaga mappings
  lspsaga.init_lsp_saga{code_action_prompt={enable=false,}}
  mapper("n", "gh", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", {silent = true, noremap = true})
  mapper("n", "ga", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {silent = true, noremap = true})
  mapper("v", "ga", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {silent = true, noremap = true})
  mapper("n", "K", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {silent = true, noremap = true})
  mapper("n", "C-f", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", {silent = true, noremap = true})
  mapper("n", "C-b", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", {silent = true, noremap = true})
  mapper("n", "gs", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", {silent = true, noremap = true})
  mapper("n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>", {silent = true, noremap = true})
  mapper("n", "gd", "gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>", {silent = true, noremap = true})
  mapper("n", "<Leader>sd", "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", {silent = true, noremap = true})
  mapper("n", "[d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", {silent = true, noremap = true})
  mapper("n", "]d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", {silent = true, noremap = true})

  -- load lsp trouble
  trouble.setup()
  mapper("n" , "<F6>", "<cmd>lua vim.lsp.stop_client(vim.lsp.buf_get_clients(0))", {silent = true, noremap = true})

  -- Diagnostic text colors
  vim.cmd[[ hi LspDiagnosticsVirtualTextError guifg = Red ctermfg = Red ]]
  vim.cmd[[ hi LspDiagnosticsVirtualTextWarning guifg = Yellow ctermfg = Yellow ]]
  vim.cmd[[ hi LspDiagnosticsVirtualTextInformation guifg = White ctermfg = White ]]
  vim.cmd[[ hi LspDiagnosticsVirtualTextHint guifg = White ctermfg = White ]]

  -- use omnifunc
  vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

-- python
lspconfig.pyright.setup({
  on_attach = function(client)
    custom_attach(client)
    -- 'Organize imports' keymap for pyright only
    mapper("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>", {silent = true, noremap = true})
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
})

lspconfig.tsserver.setup{on_attach = custom_attach} -- typescript
lspconfig.yamlls.setup{on_attach = custom_attach} -- yaml
lspconfig.bashls.setup{on_attach = custom_attach} -- bash

-- lua (optional)
local sumneko_root_path = LSP_PATH .. "lua-language-server"
local sumneko_binary = LSP_PATH .. "lua-language-server/bin/" .. my_os .. "/lua-language-server"
if vim.fn.executable(sumneko_binary) then
  lspconfig.sumneko_lua.setup({
    on_attach = custom_attach,
    cmd = { sumneko_binary, '-E',  sumneko_root_path .. '/main.lua'},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';') -- Setup lua path
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make server aware of Neovim runtime files
          library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
        }
      },
    },
  })
end

-- rust
local opts = {
  tools = { -- rust-tools options
    autoSetHints = true,  -- automatically set inlay hints (type hints)
    hover_with_actions = true,  -- whether to show hover actions inside the hover window
    runnables = { use_telescope = true }, -- These apply to the default RustRunnables command
    -- These apply to the default RustSetInlayHints command
    inlay_hints = {
      show_parameter_hints = true,  -- wheter to show parameter hints with the inlay hints or not
      parameter_hints_prefix = "<- ", -- prefix for parameter hints
      other_hints_prefix = "=> ", -- prefix for all the other hints (type, chaining)
      max_len_align = false,  -- whether to align to the length of the longest line in the file
      max_len_align_padding = 1,  -- padding from the left if max_len_align is true
      right_align = false,  -- whether to align to the extreme right or not
      right_align_padding = 7 -- padding from the right if right_align is true
    },

    hover_actions = {
      -- see vim.api.nvim_open_win()
      border = {
        {"╭", "FloatBorder"}, {"─", "FloatBorder"},
        {"╮", "FloatBorder"}, {"│", "FloatBorder"},
        {"╯", "FloatBorder"}, {"─", "FloatBorder"},
        {"╰", "FloatBorder"}, {"│", "FloatBorder"}
      },
      auto_focus = false  -- whether the hover action window gets automatically focused
    }
  },

  -- rust-analyer options
  server = {
    cmd = { LSP_PATH .. "rust-analyzer" },
    on_attach = function(client)
      custom_attach(client)
      -- 'Organize imports' keymap for pyright only
      mapper("n", "<Leader>rr", "<cmd>RustRunnables<CR>", {silent = true, noremap = true})
      mapper("n", "<Leader>ri", "<cmd>RustToggleInlayHints<CR>", {silent = true, noremap = true})
      mapper("n", "<Leader>rh", "<cmd>RustHoverActions<CR>", {silent = true, noremap = true})
      mapper("n", "<Leader>rm", "<cmd>RustExpandMacro<CR>", {silent = true, noremap = true})
    end,
  }
}

require('rust-tools').setup(opts)

-- autoformatting
lspconfig.efm.setup {
  init_options = {documentFormatting = true},
  filetypes = {"lua"},
  settings = {
    rootMarkers = {".git/"},
    languages = {
      lua = {
        {
          formatCommand = "lua-format -i --indent-width=2 --tab-width=2 --no-break-after-operator --break-after-table-lb",
          formatStdin = true
        }
      }
    }
  }
}

local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'        -- Packer can manage itself

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function()
      require('telescope').setup{
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden'
          },
          mappings = {
            i = { ["<C-d>"] = false, },
            n = { ["<C-d>"] = false, },
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = { ["<C-d>"] = require("telescope.actions").delete_buffer, },
              n = { ["<C-d>"] = require("telescope.actions").delete_buffer, },
            }
          },
        },
        file_ignore_patterns = { ".git/*" },
      }
    end
  }

  -- Colorscheme
  use {
    'mhartington/oceanic-next',
    config = function()
        vim.cmd "let g:oceanic_next_terminal_bold = 1"
        vim.cmd "let g:oceanic_next_terminal_italic = 1"
        vim.cmd "colorscheme OceanicNext"
        vim.cmd "hi Normal guibg=NONE ctermbg=NONE"
        vim.cmd "hi LineNr guibg=NONE ctermbg=NONE"
        vim.cmd "hi SignColumn guibg=NONE ctermbg=NONE"
        vim.cmd "hi EndOfBuffer guibg=NONE ctermbg=NONE"
    end
  }

  -- Git integration
  use "tpope/vim-fugitive"
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      require('gitsigns').setup()
    end
  }

  -- Icons
  use { "kyazdani42/nvim-web-devicons" }

  -- Statusline:
  use {
    "glepnir/galaxyline.nvim",
    branch = 'main',
    config = function() require'extra/statusline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  -- Colors:
  use {
    "RRethy/vim-hexokinase",
    run = 'make hexokinase',
  }

  -- Vimwiki, taskwiki
  use { "vimwiki/vimwiki", config = function() require'extra/myvimwiki' end }

  -- LSP + treesitter
  use "neovim/nvim-lsp"                             -- LSP
  use "neovim/nvim-lspconfig"                       -- basic configurations for LSP client
  use "folke/lsp-trouble.nvim"                      -- inline diagnostic info
  use {
    "nvim-treesitter/nvim-treesitter",              -- treesitter
    branch = '0.5-compat',
    run = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = 'maintained',
        highlight = {
          enable = true,
          disable = { "html" },
        },
        indent = {enable = true},
      }
    end
  }
  use "nvim-treesitter/nvim-treesitter-textobjects" -- custom text objects from treesitter
  -- use "nvim-treesitter/nvim-treesitter-refactor"    -- nice refactoring helpers
  use { "simrat39/rust-tools.nvim" }
  use { "glepnir/lspsaga.nvim" }                    -- nice lsp UI

  -- Completion
  use {
    "hrsh7th/nvim-compe",                           -- autocomplete
    requires = {
        "hrsh7th/vim-vsnip",                        -- ...w/ snippet integration
        "hrsh7th/vim-vsnip-integ",
        "rafamadriz/friendly-snippets",             -- snippets
    },
    config = function()
      require('compe').setup {
        enabled = true,
        autocomplete = true;
        preselect = 'enable',
        min_length = 1,
        source = {
          -- Passing a dict enables the completion source
          -- Menu is sorted by priority highest -> lowest
          vsnip     = {priority = 100},
          nvim_lsp    = {priority = 90},
          nvim_treesitter = {priority = 86},
          nvim_lua    = {priority = 85},
          buffer      = {priority = 80},
          path      = {priority = 70},
          calc      = {priority = 60},
        },
      }
    end
  }

  -- For auto cd
  use {
    "airblade/vim-rooter",
    config = function()
        vim.cmd "let g:rooter_change_directory_for_non_project_files = 'current'"
    end
  }

  -- directory explorer
  use { "kyazdani42/nvim-tree.lua" }

end)

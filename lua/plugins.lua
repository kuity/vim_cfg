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
  use { "nvim-lua/popup.nvim" }       -- popup windows
  use { "nvim-lua/plenary.nvim" }     -- utility functions

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
  --use {
  --  'nanotech/jellybeans.vim',
  --  config = function()
  --      vim.cmd([[let g:jellybeans_overrides = {'background': { 'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none'}}]])
  --      vim.api.nvim_command('colorscheme jellybeans')
  --  end,
  --}

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
        -- vim.api.nvim_command('colorscheme OceanicNext')
      --
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
    },
  }

  use "airblade/vim-rooter"  -- vim rooter

  -- directory explorer
  use { "kyazdani42/nvim-tree.lua" }

end)

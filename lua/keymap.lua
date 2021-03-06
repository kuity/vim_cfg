local function register_mappings(mappings, default_options)
  for mode, mode_mappings in pairs(mappings) do
    for _, mapping in pairs(mode_mappings) do
      -- check #(no.) of elems in the mapping
      -- if there's 3, pop the last 1 and assign it to options
      local options = #mapping == 3 and table.remove(mapping) or default_options
      local prefix, cmd = unpack(mapping)
      -- pcall is just lua built-in; means protected call
      pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
    end
  end
end

vim.api.nvim_exec([[
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
]], false)

local mappings = {
  i = { -- Insert mode
    -- I hate escape
    { "jk", "<ESC>" },
    { "kj", "<ESC>" },
    { "jj", "<ESC>" },

    -- Move current line / block with Alt-j/k ala vscode.
    { "<A-j>", "<Esc>:m .+1<CR>==gi" },
    { "<A-k>", "<Esc>:m .-2<CR>==gi" },

    -- Terminal window navigation
    { "<C-h>", "<C-\\><C-N><C-w>h" },
    { "<C-j>", "<C-\\><C-N><C-w>j" },
    { "<C-k>", "<C-\\><C-N><C-w>k" },
    { "<C-l>", "<C-\\><C-N><C-w>l" },

    -- Quick Save
    { "<C-s>", "<Esc>:up<CR>"},

    -- Add move line shortcuts
    { "<A-j>", "<Esc>:m .+1<CR>==gi"},
    { "<A-k>", "<Esc>:m .-2<CR>==gi"},
  },
  n = { -- Normal mode
    -- Better window movement
    { "<C-h>", "<C-w>h", { silent = true } },
    { "<C-j>", "<C-w>j", { silent = true } },
    { "<C-k>", "<C-w>k", { silent = true } },
    { "<C-l>", "<C-w>l", { silent = true } },
    { "<S-l>", "gt" },
    { "<S-h>", "gT" },

    -- Tab switch buffer
    { "<TAB>", ":bnext<CR>" },
    { "<S-TAB>", ":bprevious<CR>" },

    -- Move current line / block with Alt-j/k a la vscode.
    { "<A-j>", ":m .+1<CR>==" },
    { "<A-k>", ":m .-2<CR>==" },

    -- insert empty lines
    { "<A-CR>", "o<Esc>" },
    { "<A-BS>", "O<Esc>" },

    -- QuickFix
    { "]q", ":cnext<CR>" },
    { "[q", ":cprev<CR>" },

    -- Telescope
    { "<Leader>ff", [[:lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--no-ignore', '--hidden', '-g', '!.git/'}, prompt_prefix='????'}<CR>]] },
    { "<Leader>r", ":Telescope live_grep<CR>" },
    { "<Leader>b", ":Telescope buffers<CR>" },
    { "<Leader>cb", ":Telescope current_buffer_fuzzy_find<CR>" },
    { "<Leader>t", ":Telescope tags<CR>" },
    { "<Leader>fc", ":Telescope git_commits<CR>" },
    { "<Leader>fb", ":Telescope git_branches<CR>" },

    -- Quick Save
    { "<C-s>", ":up<CR>"},

    -- sudo write trick
    { "<Leader>w", ":w !sudo tee %<CR>" },

    -- clear highlighting
    { "<Leader>c", ":nohl<CR>" },

    -- clipboard
    { "<Leader>y", '"+y' },
    { "<Leader>p", '"+p' },

    -- fully reload neovim configuration
    { "rrr", ":lua require('utils').reload_cfg()<CR>" },

    -- fugitive mappings
    { "<Leader>g", ":G<CR>" },
    { "<Leader>gs", ":G status<CR>" },
    { "<Leader>ga", ":G add<CR>" },
    { "<Leader>gc", ":G commit<CR>" },
    { "<Leader>gp", ":G push<CR>" },

    -- Add move line shortcuts
    { "<A-j>", ":m .+1<CR>==" },
    { "<A-k>", ":m .-2<CR>==" },

    -- Nvim Tree
    { "<C-n>", ":NvimTreeToggle<CR>" },
    { "<Leader>nf", ":NvimTreeFindFile<CR>" },
    { "<Leader>nr", ":NvimTreeRefresh<CR>" },

  },
  t = { -- Terminal mode
    -- Terminal window navigation
    { "<C-h>", "<C-\\><C-N><C-w>h" },
    { "<C-j>", "<C-\\><C-N><C-w>j" },
    { "<C-k>", "<C-\\><C-N><C-w>k" },
    { "<C-l>", "<C-\\><C-N><C-w>l" },
  },
  v = { -- Visual/Select mode
    -- Better indenting
    { "<", "<gv" },
    { ">", ">gv" },

    -- clipboard
    { "<Leader>y", '"+y' },
    { "<Leader>p", '"+p' },

    -- wrap with quotes
    { "<Leader>q", [[:norm!I"<c-v><Esc>A"<CR>]] },

    -- Add move line shortcuts
    { "<A-j>", ':m \'>+1<CR>gv=gv' },
    { "<A-k>", ':m \'<-2<CR>gv=gv' },

    -- Norm shortcut on visual selection
    { "e", ":g/^/norm " },
  },
  x = { -- Visual mode
    -- Move selected line / block of text in visual mode
    { "K", ":move '<-2<CR>gv-gv" },
    { "J", ":move '>+1<CR>gv-gv" },

    -- Move current line / block with Alt-j/k ala vscode.
    { "<A-j>", ":m '>+1<CR>gv-gv" },
    { "<A-k>", ":m '<-2<CR>gv-gv" },

    -- Execute a macro
    { "@", ":<C-u>call ExecuteMacroOverVisualRange()<CR>" },
  },
  [""] = {
    -- Toggle the QuickFix window
    { "<C-q>", ":call QuickFixToggle()<CR>" },
  },
}

register_mappings(mappings, { silent = true, noremap = true })

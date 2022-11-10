local M = {}
local set = vim.keymap.set

local function map(mappings)
  for mode, mapping_table in pairs(mappings) do
    for _, mapping in pairs(mapping_table) do
      local key = mapping[1]
      local cmd = mapping[2]
      local opts = mapping[3]
      set(mode, key, cmd, opts)
    end
  end
end

local keymaps = {
  regular = {
    [{'n'}] = {
      { 'x', '"_x', { silent = true }},
      { 'j', 'gj' , { silent = true }},
      { 'k', 'gk' , { silent = true }},
      -- Better window navigation
      { '<C-j>', '<C-w>j', { silent = true } },
      { '<C-k>', '<C-w>k', { silent = true } },
      { '<C-h>', '<C-w>h', { silent = true } },
      { '<C-l>', '<C-w>l', { silent = true } },
      -- Better tabs
      { '<C-S-h>', '<Cmd>:tabprev<CR>', { silent = true } },
      { '<C-S-l>', '<Cmd>:tabnext<CR>', { silent = true } },
      { '<leader>1', '1gt', { silent = true } },
      { '<leader>2', '2gt', { silent = true } },
      { '<leader>3', '3gt', { silent = true } },
      { '<leader>4', '4gt', { silent = true } },
      { '<leader>5', '5gt', { silent = true } },
      { '<leader>6', '6gt', { silent = true } },
      { '<leader>7', '7gt', { silent = true } },
      { '<leader>8', '8gt', { silent = true } },
      { '<leader>9', '9gt', { silent = true } },
      { '<leader>0', '10gt', { silent = true } },
      -- Autoindent on insert
      { 'i', function () return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i' end, {expr=true, silent = true}},
    },
    [{'n', 'v'}] = {
      -- Better pasting
      { 'p', 'p=`]', { silent = true } },
      { 'P', 'P=`]', { silent = true } },
      {'<Space>', '<Nop>', { silent = true }},
      { '<leader>p', '"+p=`]', { silent = true } },
      { '<leader>y', '"+y"', { silent = true }},
    },
  },
  diagnostics = {
    [{ 'n' }] = {
      { '<leader>e', vim.diagnostic.open_float, {desc = 'Floating Diagnostics'}},
      { '[d', vim.diagnostic.goto_prev, {desc = 'Previous diagnostic'}},
      { ']d', vim.diagnostic.goto_next, {desc = 'Next diagnostic'}},
      { '<leader>q', vim.diagnostic.setloclist, {desc = 'Add diagnostics to location list'}},
    }
  },
  neo_tree_window = {
    [{ 'n' }] = {
      { '<leader>n', '<Cmd>Neotree toggle left reveal_force_cwd<CR>', {desc = 'Toggle Neo-tree (left) '}},
      { 'gd', '<Cmd>Neotree float reveal_file=<cfile> reveal_force_cwd<cr>', {desc = 'Popup Neo-tree for file under cursor'} }
    }
  },
  incremental_rename = { [{ 'n' }] = { { '<leader>rn', function() return "<Cmd>IncRename " .. vim.fn.expand("<cword>") end, {expr = true, desc = 'Rename (incrementally)'} }, } },
  bufferline = { [{ 'n' }] = { { 'gb', '<Cmd>BufferLinePick<CR>', {desc = 'Pick from bufferline'}} } },
  hlslens = {
    [{'n'}] = {
      { 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true} },
      { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true} },
      { '*', [[*<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true} },
      { '#', [[#<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true} },
      { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true} },
      { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true} },
      { '<Leader>l', ':noh<CR>', {noremap = true, silent = true} },
    }
  },
  matchup = { [{'n'}] = { { "<c-K>", [[<Cmd><C-u>MatchupWhereAmI?<cr>]], {desc = "(Matchup) Where am I?"} } } },
}

function M.setup(purpose)
  map(keymaps[purpose])
end

function M.setup_dial()
  local dial = require('dial.map')
  keymaps['dial'] = {
    [{'n'}] = {
      { "<c-a>", dial.inc_normal(), {noremap = true} },
      { "<c-x>", dial.dec_normal(), {noremap = true} },
    },
    [{'v'}] = {
      { "<c-a>", dial.inc_visual(), {noremap = true} },
      { "<c-x>", dial.dec_visual(), {noremap = true} },
      { "g<c-a>", dial.inc_gvisual(), {noremap = true} },
      { "g<c-x>", dial.dec_gvisual(), {noremap = true} },
    }
  }
  M.setup('dial')
end

function M.setup_telescope()
  local ts_builtin = require('telescope.builtin')
  keymaps['telescope'] = {
    [{ 'n' }] = {
      { '<leader><space>', ts_builtin.buffers, {desc = '(TS) Buffers'}},
      { '<leader>ff', ts_builtin.find_files, {desc = '(TS) Find files'}},
      { '<leader>f/', ts_builtin.current_buffer_fuzzy_find, {desc = '(TS) Fuzzy find in buffer'}},
      { '<leader>fh', ts_builtin.help_tags, {desc = '(TS) Neovim help'}},
      { '<leader>ft', ts_builtin.tags, {desc = '(TS) Tags'}},
      { '<leader>fd', ts_builtin.grep_string, {desc = '(TS) grep current string'}},
      { '<leader>fp', ts_builtin.live_grep, {desc = '(TS) live grep a string'}},
      { '<leader>fo', function() ts_builtin.tags({ only_current_buffer = true }) end, {desc = '(TS) Tags in buffer'}},
      { '<leader>?', ts_builtin.oldfiles, {desc = '(TS) Oldfiles'}},
      { '<leader>fb', "<Cmd>Telescope file_browser<CR>", {desc = '(TS) Browse files'}},
    }
  }
  M.setup('telescope')
end

-- function M.setup_fzf()
--   local fzf = require('fzf-lua')
--   keymaps['fzf'] = {
--     { '<leader><space>', fzf.buffers(), {desc = '(FZF) Buffers'}},
--     { '<leader>ff', fzf.find_files(), {desc = '(FZF) Find files'}},
--     { '<leader>f/', fzf.lgrep_curbuf(), {desc = '(FZF) Fuzzy find in buffer'}},
--     { '<leader>fh', fzf.help_tags(), {desc = '(FZF) Neovim help'}},
--     { '<leader>ft', fzf.tags(), {desc = '(FZF) Tags'}},
--     { '<leader>fd', fzf.grep_cWORD(), {desc = '(FZF) grep current string'}},
--     { '<leader>fp', fzf.live_grep(), {desc = '(FZF) live grep a string'}},
--     { '<leader>?', fzf.oldfiles(), {desc = '(FZF) Oldfiles'}},
--     { '<leader>fb', "<Cmd>Telescope file_browser<CR>", {desc = '(FZF) Browse files'}},
--   }
--   M.setup('fzf')
-- end

function M.init()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  M.setup("regular")
end

-- For other plugins

M.toggleterm = {
  open_mapping = [[<C-\>]]
}
M.neo_tree = {
  default = {
    ["<space>"] = {
      "toggle_node",
      nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
    },
    ["<2-LeftMouse>"] = "open",
    ["<cr>"] = "open",
    ["S"] = "split_with_window_picker",
    ["s"] = "vsplit_with_window_picker",
    ["t"] = "open_tabnew",
    ["w"] = "open_with_window_picker",
    ["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
    ["C"] = "close_node",
    ["z"] = "close_all_nodes",
    ["Z"] = "expand_all_nodes",
    ["a"] = {
      "add",
      -- some commands may take optional config options, see `:h neo-tree-mappings` for details
      config = {
        show_path = "none" -- "none", "relative", "absolute"
      }
    },
    ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
    ["d"] = "delete",
    ["r"] = "rename",
    ["y"] = "copy_to_clipboard",
    ["x"] = "cut_to_clipboard",
    ["p"] = "paste_from_clipboard",
    ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
    ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
    ["q"] = "close_window",
    ["R"] = "refresh",
    ["?"] = "show_help",
    ["<"] = "prev_source",
    [">"] = "next_source",
  },
  filesystem = {
    ["<bs>"] = "navigate_up",
    ["."] = "set_root",
    ["H"] = "toggle_hidden",
    ["/"] = "fuzzy_finder",
    ["D"] = "fuzzy_finder_directory",
    ["f"] = "filter_on_submit",
    ["<c-x>"] = "clear_filter",
    ["[g"] = "prev_git_modified",
    ["]g"] = "next_git_modified",
  },
  buffer = {
    ["bd"] = "buffer_delete",
    ["<bs>"] = "navigate_up",
    ["."] = "set_root",
  },
  git_status = {
    ["A"]  = "git_add_all",
    ["gu"] = "git_unstage_file",
    ["ga"] = "git_add_file",
    ["gr"] = "git_revert_file",
    ["gc"] = "git_commit",
    ["gp"] = "git_push",
    ["gg"] = "git_commit_and_push",
  }
}
M.lsp = {
  on_attach = {
    { "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>" },
    { "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>" },
    { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" },
    { "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>" },
    { "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>" },
    { "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" },
    { "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" },
    { "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>" },
    { "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
    { "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>" },
    { "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>" },
    { "n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>" }
  }
}
M.neoscroll = {
  ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150", [["sine"]] } },
  ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150", [["sine"]] } },
  ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250", [["circular"]] } },
  ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250", [["circular"]] } },
  ["<C-y>"] = { "scroll", { "-0.10", "false", "100", nil } },
  ["<C-e>"] = { "scroll", { "0.10", "false", "100", nil } },
  ["zt"]    = { "zt", { "100" } },
  ["zz"]    = { "zz", { "100" } },
  ["zb"]    = { "zb", { "100" } }
}

return M

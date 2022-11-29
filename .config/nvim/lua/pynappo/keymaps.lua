local M = {}

local function map(mappings, opts)
  for mode, mapping_table in pairs(mappings) do
    for _, mapping in pairs(mapping_table) do
      local key = mapping[1]
      local cmd = mapping[2]
      local opts = vim.tbl_deep_extend("force", mapping[3] or {}, opts or {})
      vim.keymap.set(mode, key, cmd, opts)
    end
  end
end

M.setup = {
  regular = function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    map({
      [{'n'}] = {
        { 'x', '"_x' },
        { 'j', 'gj'  },
        { 'k', 'gk'  },
        -- Better tabs
        { '<C-S-h>', '<Cmd>:tabprev<CR>' },
        { '<C-S-l>', '<Cmd>:tabnext<CR>' },
        { '<leader>1', '1gt' },
        { '<leader>2', '2gt' },
        { '<leader>3', '3gt' },
        { '<leader>4', '4gt' },
        { '<leader>5', '5gt' },
        { '<leader>6', '6gt' },
        { '<leader>7', '7gt' },
        { '<leader>8', '8gt' },
        { '<leader>9', '9gt' },
        { '<leader>0', '10gt' },
        -- Autoindent on insert
        { 'i', function () return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i' end, {expr=true}},
      },
      [{'n', 'v'}] = {
        -- Better pasting
        { 'p', 'p=`]' },
        { 'P', 'P=`]' },
        {'<Space>', '<Nop>' },
        { '<leader>p', '"+p=`]' },
        { '<leader>y', '"+y"'},
      },
      [{'i'}] = {
        {'<Up>', function() return vim.fn.pumvisible() == 1 and 'k' or '<Up>' end, {silent = true, expr = true} }
      }
    }, {silent=true})
  end,
  smart_splits = function()
    local ss = require('smart-splits')
    map({
      [{'n'}] = {
        { '<A-h>', ss.resize_left },
        { '<A-j>', ss.resize_down },
        { '<A-k>', ss.resize_up },
        { '<A-l>', ss.resize_right },
        { '<C-h>', ss.move_cursor_left },
        { '<C-j>', ss.move_cursor_down },
        { '<C-k>', ss.move_cursor_up },
        { '<C-l>', ss.move_cursor_right },
      }
    }, {silent = true})
  end,
  diagnostics = function()
    local diag = vim.diagnostic
    map({
      [{ 'n' }] = {
        { '<leader>e', diag.open_float, {desc = 'Floating Diagnostics'}},
        { '[d', diag.goto_prev, {desc = 'Previous diagnostic'}},
        { ']d', diag.goto_next, {desc = 'Next diagnostic'}},
        { '<leader>q', diag.setloclist, {desc = 'Add diagnostics to location list'}},
      }
    })
  end,
  neotree_window = function()
    map({
      [{ 'n' }] = {
        { '<leader>n', '<Cmd>Neotree toggle left reveal_force_cwd<CR>', {desc = 'Toggle Neo-tree (left) '}},
        { 'gd', '<Cmd>Neotree float reveal_file=<cfile> reveal_force_cwd<cr>', {desc = 'Popup Neo-tree for file under cursor'} }
      }
    })
  end,
  incremental_rename = function() map ({ [{ 'n' }] = { { '<leader>rn', function() return "<Cmd>IncRename " .. vim.fn.expand("<cword>") .. "<CR>" end, {expr = true, desc = 'Rename (incrementally)'} }, } })end,
  hlslens = function()
    map({
      [{'n'}] = {
        { 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
        { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
        { '*', [[*<Cmd>lua require('hlslens').start()<CR>]] },
        { '#', [[#<Cmd>lua require('hlslens').start()<CR>]] },
        { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]] },
        { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]] },
        { '<Leader>l', ':noh<CR>' },
      }
    }, {noremap = true, silent = true})
  end,
  matchup = function() map({ [{'n'}] = { { "<c-K>", [[<Cmd><C-u>MatchupWhereAmI?<cr>]], {desc = "(Matchup) Where am I?"} } } }) end,
  mini = function() map({ [{ 'n' }] = { { '<leader>m', function() require('mini.map').toggle() end, {desc = 'Toggle mini.map'}}}}) end,
  dial = function()
    map({
      [{'n'}] = {
        { "<c-a>", require('dial.map').inc_normal() },
        { "<c-x>", require('dial.map').dec_normal() },
      },
      [{'v'}] = {
        { "<c-a>", require('dial.map').inc_visual() },
        { "<c-x>", require('dial.map').dec_visual() },
        { "g<c-a>", require('dial.map').inc_gvisual() },
        { "g<c-x>", require('dial.map').dec_gvisual() },
      }
    }, {remap = false})
  end,

  telescope = function()
    local builtin = require('telescope.builtin')
    map({
      [{ 'n' }] = {
        { '<leader><space>', builtin.buffers, {desc = '(TS) Buffers'}},
        { '<leader>ff', builtin.find_files, {desc = '(TS) Find files'}},
        { '<leader>f/', builtin.current_buffer_fuzzy_find, {desc = '(TS) Fuzzy find in buffer'}},
        { '<leader>fh', builtin.help_tags, {desc = '(TS) Neovim help'}},
        { '<leader>ft', builtin.tags, {desc = '(TS) Tags'}},
        { '<leader>fd', builtin.grep_string, {desc = '(TS) grep current string'}},
        { '<leader>fp', builtin.live_grep, {desc = '(TS) live grep a string'}},
        { '<leader>fo', function() builtin.tags({ only_current_buffer = true }) end, {desc = '(TS) Tags in buffer'}},
        { '<leader>?', builtin.oldfiles, {desc = '(TS) Oldfiles'}},
        { '<leader>fb', "<Cmd>Telescope file_browser<CR>", {desc = '(TS) Browse files'}},
      }
    })
  end,
}

-- For other plugins
M.cmp = {
  insert = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    return cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto, }),
      ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
        else fallback() end
      end, { "i", "s", 'c' }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
        else fallback() end
      end, { "i", "s", 'c' }),
    })
  end,
}

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

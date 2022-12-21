local M = {}

local function map(mappings, opts)
  for mode, mapping_table in pairs(mappings) do
    for _, mapping in pairs(mapping_table) do
      local key = mapping[1]
      local cmd = mapping[2]
      opts = vim.tbl_deep_extend("force", mapping[3] or {}, opts or {})
      vim.keymap.set(mode, key, cmd, opts)
    end
  end
end

M.setup = {
  regular = function()
    vim.keymap.set({ 'n', 'v' }, 'p', 'p=`]', {silent = true})
    vim.keymap.set({ 'n', 'v' }, 'P', 'P=`]', {silent = true})
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', {silent = true})
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
        { '<Esc>', '<Cmd>nohl<CR>'},
        -- Autoindent on insert
        { 'i', function () return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i' end, {expr=true}},
      },
      [{'n', 'v'}] = {
        -- {'p', 'p=`]'},
        -- {'P', 'P=`]'},
        {'Space', '<Nop>' },
        -- {'<leader>p', '"+p'}
      },
    }, {silent=true})
  end,
  smart_splits = function()
    local ss = require('smart-splits')
    map({
      [{'n', 't'}] = {
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
  treesj = function()
    map({
      [{'n'}] = { {'gJ', '<Cmd>TSJToggle<CR>', {desc = 'Split/join line'} } }
    })
  end,
  lsp = function(bufnr)
    map({
      [{'n'}] = {
        { 'gD', vim.lsp.buf.declaration },
        { 'gd', vim.lsp.buf.definition },
        { 'K', vim.lsp.buf.hover },
        { 'gi', vim.lsp.buf.implementation },
        { '<C-k>', vim.lsp.buf.signature_help },
        { '<leader>wa', vim.lsp.buf.add_workspace_folder },
        { '<leader>wr', vim.lsp.buf.remove_workspace_folder },
        { '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end},
        { '<leader>D', vim.lsp.buf.type_definition },
        { '<leader>rn', vim.lsp.buf.rename },
        { '<leader>ca', vim.lsp.buf.code_action },
        { 'gr', vim.lsp.buf.references },
        { '<leader>f', function() vim.lsp.buf.format({ async = true }) end },
      }
    }, { remap=false, silent=true, buffer=bufnr })
  end,
  jdtls = function(bufnr)
    local jdtls = require('jdtls')
    map({
      [{'n'}] = {
        { "<A-o>", jdtls.organize_imports },
        { "<leader>tc", jdtls.test_class },
        { "<leader>tm", jdtls.test_nearest_method },
        { "crv", jdtls.extract_variable },
        { "crc", jdtls.extract_constant },
        { "<leader>tr", require('jdtls.dap').setup_dap_main_class_configs() }
      },
      [{'v'}] = {
        { 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]] }
      }
    }, {buffer = bufnr})
  end,
  dap = function()
    local dap = require('dap')
    map({
      [{'n'}] = {
        { '<F5>', function() dap.continue() end },
        { '<leader>db', function() dap.toggle_breakpoint() end },
        { '<leader>dB', function() dap.set_breakpoint() end },
        { '<leader>dc', function() dap.disconnect() end },
        { '<leader>dk', function() dap.up() end },
        { '<leader>dj', function() dap.down() end },
        { '<leader>dh', function() dap.left() end },
        { '<leader>dl', function() dap.right() end },
        { '<leader>di', function() dap.step_into() end },
        { '<leader>do', function() dap.step_out() end },
        { '<leader>du', function() dap.step_over() end },
        { '<leader>ds', function() dap.stop() end },
        { '<leader>dn', function() dap.run_to_cursor() end },
        { '<leader>dR', function() dap.repl.run_last() end },
        { '<leader>de', function() dap.set_exception_breakpoints() end },
        { '<leader>dv', function() dap.variables() end },
        { '<leader>df', function() dap.set_function_breakpoints() end },
        { '<leader>dr', function() dap.repl.open() end },
      }
    })
  end,
  dapui = function()
    local dapui = require('dapui')
    map({
      [{'n'}] = {
        {'<S-F5>', function() dapui.toggle() end},
        {'<S-F6>', function() dapui.close() end},
        {'<S-F7>', function() dapui.float_element() end},
        {'<S-F8>', function() dapui.float_terminal() end},
        {'<S-F9>', function() dapui.float_scopes() end},
        {'<S-F10>', function() dapui.float_breakpoints() end},
        {'<S-F11>', function() dapui.float_stacks() end},
        {'<S-F12>', function() dapui.float_variables() end},
      }
    })
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
  incremental_rename = function() map ({ [{ 'n' }] = { { '<leader>rn', function() return "<Cmd>IncRename " .. vim.fn.expand("<cword>") end, {expr = true, desc = 'Rename (incrementally)'} }, } })end,
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
    local dial = require('dial.map')
    map({
      [{'n'}] = {
        { "<c-a>", dial.inc_normal() },
        { "<c-x>", dial.dec_normal() },
      },
      [{'v'}] = {
        { "<c-a>", dial.inc_visual() },
        { "<c-x>", dial.dec_visual() },
        { "g<c-a>", dial.inc_gvisual() },
        { "g<c-x>", dial.dec_gvisual() },
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
        if luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
        elseif cmp.visible() then cmp.select_next_item()
        else fallback() end
      end, { "i", "s", 'c' }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then luasnip.jump(-1)
        elseif cmp.visible() then cmp.select_prev_item()
        else fallback() end
      end, { "i", "s", 'c' }),
    })
  end,
}

M.toggleterm = { open_mapping = [[<C-\>]] }
M.neotree = {
  default = {
    ['<tab>'] = function (state)
      local node = state.tree:get_node()
      if require("neo-tree.utils").is_expandable(node) then
        state.commands["toggle_node"](state)
      else
        state.commands['open'](state)
        vim.cmd('Neotree reveal')
      end
    end,
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
    ["P"] = { "toggle_preview", config = {use_float = true} },
    ["C"] = "close_node",
    ["z"] = "close_all_nodes",
    ["Z"] = "expand_all_nodes",
    ["a"] = { "add", config = { show_path = "relative" } },
    ["A"] = { "add_directory", config = { show_path = "relative" } },
    ["h"] = function(state)
      local node = state.tree:get_node()
      if node.type == 'directory' and node:is_expanded() then
        require'neo-tree.sources.filesystem'.toggle_directory(state, node)
      else
        require'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
      end
    end,
    ["l"] = function(state)
      local node = state.tree:get_node()
      if node.type == 'directory' then
        if not node:is_expanded() then
          require'neo-tree.sources.filesystem'.toggle_directory(state, node)
        elseif node:has_children() then
          require'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
        end
      end
    end,
    ["d"] = "delete",
    ["r"] = "rename",
    ["y"] = "copy_to_clipboard",
    ["x"] = "cut_to_clipboard",
    ["p"] = "paste_from_clipboard",
    ["c"] = "copy",
    ["m"] = "move",
    ["q"] = "close_window",
    ["R"] = "refresh",
    ["?"] = "show_help",
    ["<"] = "prev_source",
    [">"] = "next_source",
    ["e"] = function() vim.cmd("Neotree focus filesystem left") end,
    ["b"] = function() vim.cmd("Neotree focus buffers left") end,
    ["g"] = function() vim.cmd("Neotree focus git_status left") end,
  },
  filesystem = {
    ["tf"] = "telescope_find",
    ["tg"] = "telescope_grep",
    ["<bs>"] = "navigate_up",
    ["."] = "set_root",
    ["i"] = "run_command",
    ["o"] = "system_open",
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
  },
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

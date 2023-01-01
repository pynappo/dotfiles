local M = {}

local function map(keymaps, opts, extra_opts)
  local lazy_keymaps = {}
  extra_opts = extra_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      opts = vim.tbl_extend('force', opts or {}, m[3] or {})
      if extra_opts.lazy then table.insert(lazy_keymaps, vim.tbl_extend('force', {m[1], m[2], mode = modes}, opts))
      else vim.keymap.set(modes, m[1], m[2], opts) end
    end
  end
  return lazy_keymaps
end

M.setup = {
  regular = function()
    vim.keymap.set({ 'n', 'v' }, 'p', 'p=`]', { silent = true })
    vim.keymap.set({ 'n', 'v' }, 'P', 'P=`]', { silent = true })
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { silent = true })
    map({
      [{ 'n' }] = {
        { 'x', '"_x' },
        { 'j', 'gj' },
        { 'k', 'gk' },
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
        { '<Esc>', '<Cmd>nohl<CR>' },
        -- Autoindent on insert
        {
          'i',
          function() return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i' end,
          { expr = true },
        },
      },
      [{ 'n', 'v' }] = {
        -- {'p', 'p=`]'},
        -- {'P', 'P=`]'},
        { 'Space', '<Nop>' },
        -- {'<leader>p', '"+p'}
      },
    }, { silent = true })
  end,
  smart_splits = function()
    map({
      [{ 'n', 't' }] = {
        { '<A-h>', function() require('smart-splits').resize_left() end },
        { '<A-j>', function() require('smart-splits').resize_down() end },
        { '<A-k>', function() require('smart-splits').resize_up() end },
        { '<A-l>', function() require('smart-splits').resize_right() end },
        { '<C-h>', function() require('smart-splits').move_cursor_left() end },
        { '<C-j>', function() require('smart-splits').move_cursor_down() end },
        { '<C-k>', function() require('smart-splits').move_cursor_up() end },
        { '<C-l>', function() require('smart-splits').move_cursor_right() end },
      },
    }, { silent = true })
  end,
  treesj = function(opts)
    map({
      [{ 'n' }] = { { 'gJ', '<Cmd>TSJToggle<CR>', { desc = 'Split/join line' } } },
    }, {}, opts)
  end,
  lsp = function(bufnr)
    map({
      [{ 'n' }] = {
        { 'gD', vim.lsp.buf.declaration },
        { 'gd', vim.lsp.buf.definition },
        { 'K', vim.lsp.buf.hover },
        { 'gi', vim.lsp.buf.implementation },
        { '<C-k>', vim.lsp.buf.signature_help },
        { '<leader>wa', vim.lsp.buf.add_workspace_folder },
        { '<leader>wr', vim.lsp.buf.remove_workspace_folder },
        { '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end },
        { '<leader>D', vim.lsp.buf.type_definition },
        { 'ga', vim.lsp.buf.code_action },
        { 'gr', vim.lsp.buf.references },
        { '<leader>f', function() vim.lsp.buf.format({ async = true }) end },
      },
    }, { remap = false, silent = true, buffer = bufnr })
  end,
  jdtls = function(bufnr)
    local jdtls = require('jdtls')
    map({
      [{ 'n' }] = {
        { '<A-o>', jdtls.organize_imports },
        { '<leader>tc', jdtls.test_class },
        { '<leader>tm', jdtls.test_nearest_method },
        { 'crv', jdtls.extract_variable },
        { 'crc', jdtls.extract_constant },
        { '<leader>tr', require('jdtls.dap').setup_dap_main_class_configs() },
      },
      [{ 'v' }] = {
        { 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]] },
      },
    }, { buffer = bufnr })
  end,
  dap = function()
    local d = require('dap')
    map({
      [{ 'n' }] = {
        { '<F5>', d.continue },
        { '<leader>db', d.toggle_breakpoint },
        { '<leader>dB', d.set_breakpoint },
        { '<leader>dc', d.disconnect },
        { '<leader>dk', d.up },
        { '<leader>dj', d.down },
        { '<leader>di', d.step_into },
        { '<leader>do', d.step_out },
        { '<leader>du', d.step_over },
        { '<leader>ds', d.stop },
        { '<leader>dn', d.run_to_cursor },
        { '<leader>de', d.set_exception_breakpoints },
      },
    })
  end,
  dapui = function()
    local ui = require('dapui')
    map({
      [{ 'n' }] = {
        { '<S-F5>', ui.toggle },
        { '<S-F6>', ui.close },
        { '<S-F7>', ui.float_element },
      },
    })
  end,
  diagnostics = function()
    map({
      [{ 'n' }] = {
        { '<leader>e', vim.diagnostic.open_float, { desc = 'Floating Diagnostics' } },
        { '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' } },
        { ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' } },
        { '<leader>q', vim.diagnostic.setloclist, { desc = 'Add diagnostics to location list' } },
      },
    })
  end,
  incremental_rename = function()
    map({
      [{ 'n' }] = {
        {
          '<leader>rn',
          function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
          { expr = true, desc = 'Rename (incrementally)' },
        },
      },
    })
  end,
  hlslens = function(opts)
    map({
      [{ 'n' }] = {
        { 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
        { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
        { '*', [[*<Cmd>lua require('hlslens').start()<CR>]] },
        { '#', [[#<Cmd>lua require('hlslens').start()<CR>]] },
        { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]] },
        { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]] },
        { '<Leader>l', ':noh<CR>' },
      },
    }, { noremap = true, silent = true }, opts)
  end,
  matchup = function()
    map({
      [{ 'n' }] = { { '<c-K>', [[<Cmd><C-u>MatchupWhereAmI?<cr>]], { desc = '(Matchup) Where am I?' } } },
    })
  end,
  mini = function()
    map({
      [{ 'n' }] = { { '<leader>m', function() require('mini.map').toggle() end, { desc = 'Toggle mini.map' } } },
    })
  end,
  dial = function()
    local dial = require('dial.map')
    map({
      [{ 'n' }] = {
        { '<c-a>', dial.inc_normal() },
        { '<c-x>', dial.dec_normal() },
      },
      [{ 'v' }] = {
        { '<c-a>', dial.inc_visual() },
        { '<c-x>', dial.dec_visual() },
        { 'g<c-a>', dial.inc_gvisual() },
        { 'g<c-x>', dial.dec_gvisual() },
      },
    }, { remap = false })
  end,
  telescope = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader><space>', function() require('telescope.builtin').buffers() end, { desc = '(TS) Buffers' } },
        { '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = '(TS) Find files' } },
        {
          '<leader>f/',
          function() require('telescope.builtin').current_buffer_fuzzy_find() end,
          { desc = '(TS) Fuzzy find in buffer' },
        },
        { '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = '(TS) Neovim help' } },
        { '<leader>ft', function() require('telescope.builtin').tags() end, { desc = '(TS) Tags' } },
        { '<leader>fd', function() require('telescope.builtin').grep_string() end, { desc = '(TS) grep current string' } },
        { '<leader>fp', function() require('telescope.builtin').live_grep() end, { desc = '(TS) live grep a string' } },
        {
          '<leader>fo',
          function() require('telescope.builtin').tags({ only_current_buffer = true }) end,
          { desc = '(TS) Tags in buffer' },
        },
        { '<leader>?', function() require('telescope.builtin').oldfiles() end, { desc = '(TS) Oldfiles' } },
        { '<leader>fb', '<Cmd>Telescope file_browser<CR>', { desc = '(TS) Browse files' } },
      },
    }, {}, opts)
  end,
  neo_tree = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader>n', '<Cmd>Neotree toggle left reveal_force_cwd<CR>', { desc = 'Toggle Neo-tree (left) ' } },
        {
          'gd',
          '<Cmd>Neotree float reveal_file=<cfile> reveal_force_cwd<cr>',
          { desc = 'Popup Neo-tree for file under cursor' },
        },
      },
    }, {}, opts)
  end
}

M.cmp = {
  insert = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    return cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto }),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { 'i', 's', 'c' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's', 'c' }),
    })
  end,
}

M.toggleterm = { open_mapping = [[<C-\>]] }
M.neotree = {
  default = {
    ['<tab>'] = function(state)
      local node = state.tree:get_node()
      if require('neo-tree.utils').is_expandable(node) then
        state.commands['toggle_node'](state)
      else
        state.commands['open'](state)
        vim.cmd('Neotree reveal')
      end
    end,
    ['<space>'] = {
      'toggle_node',
      nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
    },
    ['<2-LeftMouse>'] = 'open',
    ['<cr>'] = 'open',
    ['S'] = 'split_with_window_picker',
    ['s'] = 'vsplit_with_window_picker',
    ['t'] = 'open_tabnew',
    ['w'] = 'open_with_window_picker',
    ['P'] = { 'toggle_preview', config = { use_float = true } },
    ['C'] = 'close_node',
    ['z'] = 'close_all_nodes',
    ['Z'] = 'expand_all_nodes',
    ['a'] = { 'add', config = { show_path = 'relative' } },
    ['A'] = { 'add_directory', config = { show_path = 'relative' } },
    ['h'] = function(state)
      local node = state.tree:get_node()
      if node.type == 'directory' and node:is_expanded() then
        require('neo-tree.sources.filesystem').toggle_directory(state, node)
      else
        require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
      end
    end,
    ['l'] = function(state)
      local node = state.tree:get_node()
      if node.type == 'directory' then
        if not node:is_expanded() then
          require('neo-tree.sources.filesystem').toggle_directory(state, node)
        elseif node:has_children() then
          require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
        end
      end
    end,
    ['d'] = 'delete',
    ['r'] = 'rename',
    ['y'] = 'copy_to_clipboard',
    ['x'] = 'cut_to_clipboard',
    ['p'] = 'paste_from_clipboard',
    ['c'] = 'copy',
    ['m'] = 'move',
    ['q'] = 'close_window',
    ['R'] = 'refresh',
    ['?'] = 'show_help',
    ['<'] = 'prev_source',
    ['>'] = 'next_source',
    ['e'] = function() vim.cmd('Neotree focus filesystem left') end,
    ['b'] = function() vim.cmd('Neotree focus buffers left') end,
    ['g'] = function() vim.cmd('Neotree focus git_status left') end,
  },
  filesystem = {
    ['tf'] = 'telescope_find',
    ['tg'] = 'telescope_grep',
    ['<bs>'] = 'navigate_up',
    ['.'] = 'set_root',
    ['i'] = 'run_command',
    ['o'] = 'system_open',
    ['H'] = 'toggle_hidden',
    ['/'] = 'fuzzy_finder',
    ['D'] = 'fuzzy_finder_directory',
    ['f'] = 'filter_on_submit',
    ['<c-x>'] = 'clear_filter',
    ['[g'] = 'prev_git_modified',
    [']g'] = 'next_git_modified',
  },
  buffer = {
    ['bd'] = 'buffer_delete',
    ['<bs>'] = 'navigate_up',
    ['.'] = 'set_root',
  },
  git_status = {
    ['A'] = 'git_add_all',
    ['gu'] = 'git_unstage_file',
    ['ga'] = 'git_add_file',
    ['gr'] = 'git_revert_file',
    ['gc'] = 'git_commit',
    ['gp'] = 'git_push',
    ['gg'] = 'git_commit_and_push',
  },
}
M.neoscroll = {
  ['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150', [["sine"]] } },
  ['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150', [["sine"]] } },
  ['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250', [["circular"]] } },
  ['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250', [["circular"]] } },
  ['<C-y>'] = { 'scroll', { '-0.10', 'false', '100', nil } },
  ['<C-e>'] = { 'scroll', { '0.10', 'false', '100', nil } },
  ['zt'] = { 'zt', { '100' } },
  ['zz'] = { 'zz', { '100' } },
  ['zb'] = { 'zb', { '100' } },
}

return M

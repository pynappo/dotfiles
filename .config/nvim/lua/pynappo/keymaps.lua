local M = {}

local function map(keymaps, keymap_opts, extra_opts)
  extra_opts = extra_opts or {}
  local lazy_keymaps = extra_opts.lazy and {}
  keymap_opts = keymap_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      local opts = vim.tbl_extend('force', keymap_opts, m[3] or {})
      if extra_opts.lazy then table.insert(lazy_keymaps, vim.tbl_extend('force', {m[1], m[2], mode = modes}, opts))
      else
        vim.keymap.set(modes, m[1], m[2], opts)
      end
    end
  end
  return lazy_keymaps
end

local mode_tables = {}

local KeymapTable = {
  keymaps = {}
}

function KeymapTable:new(object, keymaps)
  local object = {} or object
  setmetatable(object, self)
  self.__index = self
  self.__tostring = function() return (vim.inspect(self:get_keymaps(true)):gsub([[\n]], '\n')) end
  self.keymaps = keymaps or {}
  return object
end

function KeymapTable:insert(modes, lhs, rhs, opts, function_code)
  local mode_table = type(modes) == 'table' and modes or {modes}
  table.sort(mode_table)
  local mode_string = table.concat(mode_table, '')
  mode_tables[mode_string] = mode_tables[mode_string] or mode_table
  local m = mode_tables[mode_string]
  if not self.keymaps[m] then self.keymaps[m] = {} end
  table.insert(self.keymaps[m], {lhs, rhs, opts, function_code})
end

function KeymapTable:get_keymaps(function_code)
  if not function_code then return self.keymaps end
  local new_keymaps = vim.deepcopy(self.keymaps)
  for modes, mappings in pairs(new_keymaps) do
    new_keymaps[modes] = vim.tbl_map(function(mapping) return {mapping[1], mapping[4], mapping[3]} end, mappings)
  end
  return new_keymaps
end

-- converts vim.keymap.set calls to my keymap format
function M.convert_from_api(from_register, to_register)
  local register_text = vim.fn.getreg(from_register or '+')
  local keymap_table = KeymapTable:new()
  for args_string in (register_text):gmatch("set(%b())") do
    local args_table = (loadstring('return {' .. args_string:sub(2, -2) .. '}'))()
    if type(args_table[3]) == 'function' then args_table[3] = args_string:match('.-,.-,(.-),') end
    keymap_table:insert(unpack(args_table))
  end
  return keymap_table:get_keymaps()
end

-- converts lazy plugin spec to my keymap format
function M.convert_from_lazy(lazy_keys, from_register, to_register)
  local functions, register_text
  if not lazy_keys then
    -- HACK: idk how packer.nvim is able to copy function code but this gmatch will do for now
    functions = {}
    register_text = vim.fn.getreg(from_register or '+'):match("keys.-(%b{})")
    for func in register_text:gmatch("(function.-end,)") do table.insert(functions, func) end
  end
  lazy_keys = lazy_keys or (loadstring('return ' .. register_text))()
  local keymap_table = KeymapTable:new()
  for i, keymap in ipairs(lazy_keys) do
    local key = keymap[1]
    local rhs = keymap[2]
    local mode = keymap.mode
    local opts = keymap
    opts[1], opts[2], opts.mode = nil, nil, nil
    keymap_table:insert(mode, key, rhs, opts, (type(rhs) == 'function' and functions[i] or ('function_' .. i)))
  end
  print(keymap_table)
  return keymap_table:get_keymaps(true)
end

M.setup = {
  regular = function()
    local autoindent = function(key)
      return function() return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or key end
    end
    map({
      [{ 'n', 't' }] = {
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

        { '<Esc>', vim.cmd.nohlsearch },
        { '<leader>q', vim.cmd.bdelete },
        -- Autoindent on insert/append
        { 'I', autoindent('I'), { expr = true } },
        { 'i', autoindent('i'), { expr = true } },
        { 'a', autoindent('a'), { expr = true } },
        { 'A', autoindent('A'), { expr = true } }
      },
      [{ 'n', 'v' }] = {
        { 'j', function() return vim.v.count > 0 and 'j' or 'gj' end, {expr = true} },
        { 'k', function() return vim.v.count > 0 and 'k' or 'gk' end, {expr = true} },
        { 'p', 'p=`]`' },
        { 'P', 'P=`]`' },
        {'<leader>p', '"+p'},
        {'<leader>y', '"+y'},
        { 'x', '"_x' },
      },
      [{'v'}] = {
        {'I', function()
          local old = vim.o.cursorcolumn
          if vim.fn.mode() == "\22" then vim.o.cursorcolumn = true end
          vim.api.nvim_create_autocmd('InsertLeave', { once = true, callback = function() vim.o.cursorcolumn = old end })
          return vim.fn.mode() == [[\22n]] and 'I' or [[<Esc>`<i]]
        end, {expr = true} },
        {'A', function() return vim.fn.mode() == [[\22n]] and 'A' or [[<Esc>`>a]] end, {expr = true} },
      }
    }, { silent = true })
  end,
  substitute = function(opts)
    return map({
      [{'n'}] = {
        { "r", function() require('substitute').operator() end, },
        { "rr", function() require('substitute').line() end, },
        { "R", function() require('substitute').eol() end, },
        { "<leader>r", function() require('substitute.range').operator() end, },
        { "<leader>rr", function() require('substitute.range').word() end, },
      },
      [{'x'}] = {
        { 'r', function() require('substitute').visual() end },
        { "<leader>r", function() require('substitute.range').visual() end, },
      }
    }, {}, opts)
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
    return map({
      [{ 'n' }] = { { 'gJ', '<Cmd>TSJToggle<CR>', { desc = 'Split/join line' } } },
    }, {}, opts)
  end,
  lsp = function(bufnr)
    local lsp = vim.lsp.buf
    map({
      [{ 'n' }] = {
        { 'gD', lsp.declaration, {desc = '(LSP) Get declaration'} },
        { 'gd', lsp.definition, {desc = '(LSP) Get definition'} },
        { 'K', lsp.hover, {desc = '(LSP) Get definition'}},
        { 'gi', lsp.implementation, {desc = '(LSP) Get implementation'}},
        { '<C-k>', lsp.signature_help, {desc = '(LSP) Get signature help'}},
        { '<leader>wa', lsp.add_workspace_folder, {desc = '(LSP) Add workspace folder'}},
        { '<leader>wr', lsp.remove_workspace_folder, {desc = '(LSP) Remove workspace folder'}},
        { '<leader>wl', function() vim.pretty_print(lsp.list_workspace_folders()) end, {desc = '(LSP) Get workspace folders'} },
        { '<leader>D', lsp.type_definition, {desc = '(LSP) Get type'} },
        { 'ga', lsp.code_action, {desc = '(LSP) Get code actions'}},
        { 'gr', lsp.references, {desc = '(LSP) Get references'}},
        {
          '<leader>f',
          function()
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.bo[buf].filetype
            local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
            lsp.format({
              async = true,
              filter = function(client)
                return have_nls and client.name == "null-ls" or client.name ~= "null-ls"
              end
            })
          end,
          { desc = '(LSP) Format (priority to null-ls)' },
        },
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
    local dap = require('dap')
    map({
      [{ 'n' }] = {
        { '<F5>', dap.continue },
        { '<leader>db', dap.toggle_breakpoint },
        { '<leader>dB', dap.set_breakpoint },
        { '<leader>dc', dap.disconnect },
        { '<leader>dk', dap.up },
        { '<leader>dj', dap.down },
        { '<leader>di', dap.step_into },
        { '<leader>do', dap.step_out },
        { '<leader>du', dap.step_over },
        { '<leader>ds', dap.stop },
        { '<leader>dn', dap.run_to_cursor },
        { '<leader>de', dap.set_exception_breakpoints },
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
    local diag = vim.diagnostic
    map({
      [{ 'n' }] = {
        { '<leader>e', diag.open_float, { desc = 'Floating Diagnostics' } },
        { '[d', diag.goto_prev, { desc = 'Previous diagnostic' } },
        { ']d', diag.goto_next, { desc = 'Next diagnostic' } },
        { '<leader>q', diag.setloclist, { desc = 'Add diagnostics to location list' } },
      },
    })
  end,
  incremental_rename = function()
    map({
      [{ 'n' }] = {
        {
          '<leader>',
          function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
          { expr = true, desc = 'Rename (incrementally)' },
        },
      },
    })
  end,
  hlslens = function(opts)
    return map({
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
  marks = function(opts)
    local normal = {'n'}
    local keymaps = {
      [normal] = {
        { 'm' , '<Plug>(Marks-set)' },
        { 'm,' , '<Plug>(Marks-setnext)' },
        { 'm;' , '<Plug>(Marks-toggle)' },
        { 'dm' , '<Plug>(Marks-delete)' },
        { 'dm-' , '<Plug>(Marks-deleteline)' },
        { 'dm<Space>' , '<Plug>(Marks-deletebuf)' },
        { 'm:' , '<Plug>(Marks-preview)' },
        { 'm]' , '<Plug>(Marks-next)' },
        { 'm[' , '<Plug>(Marks-prev)' },
        { 'dm=' , '<Plug>(Marks-delete-bookmark)' },
        { 'm}' , '<Plug>(Marks-next-bookmark)' },
        { 'm{' , '<Plug>(Marks-prev-bookmark)' },
      }
    }
    for i=0,9 do
      local stri = tostring(i)
      local temp = {
        ['m'..stri] = '<Plug>(Marks-set-bookmark'..stri..')',
        ['dm'..stri] = '<Plug>(Marks-delete-bookmark'..stri..')',
        ['m}'..stri] = '<Plug>(Marks-next-bookmark'..stri..')',
        ['m{'..stri] = '<Plug>(Marks-prev-bookmark'..stri..')'
      }
      for k, v in pairs(temp) do table.insert(keymaps[normal], {k,v}) end
    end
    return map(keymaps, {}, opts)
  end,
  mini = function()
    return map({
      [{'n'}] = {
        {'<M-h>', function() require('mini.move').move_line('left') end, desc = 'Move line left'},
        {'<M-j>', function() require('mini.move').move_line('down') end, desc = 'Move line down'},
        {'<M-k>', function() require('mini.move').move_line('up') end, desc = 'Move line up'},
        {'<M-l>', function() require('mini.move').move_line('right') end, desc = 'Move line right'}
      },
      [{'v'}] = {
        {'<M-h>', function() require('mini.move').move_selection('left') end, desc = 'Move selection left'},
        {'<M-j>', function() require('mini.move').move_selection('down') end, desc = 'Move selection down'},
        {'<M-k>', function() require('mini.move').move_selection('up') end, desc = 'Move selection up'},
        {'<M-l>', function() require('mini.move').move_selection('right') end, desc = 'Move selection right'},
      }
    })
  end,
  dial = function(opts)
    return map({
      [{ 'n' }] = {
        { '<C-a>', function() require('dial.map').inc_normal() end },
        { '<C-x>', function() require('dial.map').dec_normal() end },
      },
      [{ 'v' }] = {
        { '<C-a>', function() require('dial.map').inc_visual() end },
        { '<C-x>', function() require('dial.map').dec_visual() end },
        { 'g<C-a>', function() require('dial.map').inc_gvisual() end },
        { 'g<c-x>', function() require('dial.map').dec_gvisual() end },
      },
    }, {}, opts)
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
  neotree = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader>n', '<Cmd>Neotree toggle left reveal_force_cwd<CR>', { desc = 'Toggle Neo-tree (left) ' } },
        {
          '<leader>gn',
          '<Cmd>Neotree float reveal_file=<cfile> reveal_force_cwd<cr>',
          { desc = 'Popup Neo-tree for file under cursor' },
        },
      },
    }, {}, opts)
  end,
  move = function(opts)
    return map({
      [{'i'}] = {
        { '<A-j>', '<Cmd>MoveLine(1)<CR>' },
        { '<A-k>', '<Cmd>MoveLine(-1)<CR>' },
        { '<A-h>', '<Cmd>MoveHChar(-1)<CR>' },
        { '<A-l>', '<Cmd>MoveHChar(1)<CR>' }
      },
      [{'v'}] = {
        { '<A-j>', '<Cmd>MoveBlock(1)<CR>', },
        { '<A-k>', '<Cmd>MoveBlock(-1)<CR>' },
        { '<A-h>', '<Cmd>MoveHBlock(-1)<CR>' },
        { '<A-l>', '<Cmd>MoveHBlock(1)<CR>' }
      }
    }, {}, opts)
  end,
  yanky = function(opts)
    return map({
      [{'n', 'v'}] = {
        { "p", "<Plug>(YankyPutAfter)" },
        { "P", "<Plug>(YankyPutBefore)" },
        { "gp", "<Plug>(YankyGPutAfter)" },
        { "gP", "<Plug>(YankyGPutBefore)" },
        { "<c-n>", "<Plug>(YankyCycleForward)" },
        { "<c-p>", "<Plug>(YankyCycleBackward)" },
        { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
        { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
        { "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
        { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },

        { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
        { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
        { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
        { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },

        { "=p", "<Plug>(YankyPutAfterFilter)" },
        { "=P", "<Plug>(YankyPutBeforeFilter)" },
      }
  flash = function(opts)
    map({
      [{ "n", "o", "x" }] = {
        { "s", function() require("flash").jump() end, { desc = "Flash" } },
        { "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },
      },
      [{ "c" }] = { { "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" } } },
      [{ "o", "x" }] = { { "R", function() require("flash").treesitter_search() end, { desc = "Flash Treesitter Search" } } },
      [{ "o" }] = { { "r", function() require("flash").remote() end, { desc = "Remote Flash" } } }
    }, {}, opts)
  end
}
-- Other random plugin-specific mapping tables go here: --

M.cmp = {
  insert = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    return cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-s>'] = cmp.mapping(function(_) cmp.mapping.complete({ reason = cmp.ContextReason.Auto }) end, {'i'}),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item()
        elseif luasnip.jumpable(1) then luasnip.jump(1)
        else fallback() end
      end, { 'i', 's', 'c' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
        else fallback() end
      end, { 'i', 's', 'c' }),
    })
  end,
}

M.toggleterm = { open_mapping = [[<C-\>]] }
M.neotree = {
  window = {
    mappings = {
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
  },
  filesystem = {
    window = {
      mappings = {
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
      }
    }
  },
  buffers = {
    window = {
      mappings = {
        ['bd'] = 'buffer_delete',
        ['<bs>'] = 'navigate_up',
        ['.'] = 'set_root',
      }
    }
  },
  git_status = {
    window = {
      mappings = {
        ['A'] = 'git_add_all',
        ['gu'] = 'git_unstage_file',
        ['ga'] = 'git_add_file',
        ['gr'] = 'git_revert_file',
        ['gc'] = 'git_commit',
        ['gp'] = 'git_push',
        ['gg'] = 'git_commit_and_push',
      }
    }
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

M.treesitter = {
  textsubjects = {
    keymaps = {
      ['.'] = 'textsubjects-smart',
      ['a.'] = 'textsubjects-container-outer',
      ['i.'] = 'textsubjects-container-inner',
    },
  },
  incremental_selection = {
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    },
  },
  swap = {
    swap_next = {
      ["<leader>a"] = "@parameter.inner",
    },
    swap_previous = {
      ["<leader>A"] = "@parameter.inner",
    },
  },
  move = {
    goto_next_start = {
      [']m'] = '@function.outer',
      [']]'] = '@class.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
      [']['] = '@class.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[['] = '@class.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
      ['[]'] = '@class.outer',
    },
  },
}
return M

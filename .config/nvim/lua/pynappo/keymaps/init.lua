local M = {}

local function map(keymaps, keymap_opts, extra_opts)
  extra_opts = extra_opts or {}
  local lazy_keymaps = extra_opts.lazy and {}
  keymap_opts = keymap_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      local opts = vim.tbl_extend('force', keymap_opts, m[3] or {})
      if extra_opts.lazy then
        table.insert(lazy_keymaps, vim.tbl_extend('force', { m[1], m[2], mode = modes }, opts))
      else
        vim.keymap.set(modes, m[1], m[2], opts)
      end
    end
  end
  return lazy_keymaps
end

function M.fish_style_abbr(abbr, expansion)
  return {
    abbr,
    function()
      local cmdline = vim.fn.getcmdline()
      local first_word = cmdline:match('%S+')
      local typing_command = vim.fn.getcmdtype() == ':' and vim.fn.getcmdpos() == (#first_word + 1)
      if not typing_command then return abbr end
      if type(expansion) == 'function' then return expansion() or abbr end
      return expansion
    end,
    { remap = false, expr = true },
  }
end

M.setup = {
  regular = function()
    local autoindent = function(key)
      return function()
        if vim.bo[0].buftype == 'prompt' then return key end
        return not vim.api.nvim_get_current_line():match('%g') and 'cc' or key
      end
    end
    map({
      [{ 'n' }] = {
        -- { '<Tab>', vim.cmd.bnext },
        -- { '<S-Tab>', vim.cmd.bprevious },
        { 'I', autoindent('I'), { expr = true } },
        { 'i', autoindent('i'), { expr = true } },
        { 'a', autoindent('a'), { expr = true } },
        { 'A', autoindent('A'), { expr = true } },
        { 'x', '"_dl' },
        { 'X', '"_dh' },
        {
          '<leader>cmp',
          function()
            vim.g.cmp_disable = not vim.g.cmp_disable
            vim.notify((vim.g.cmp_disable and 'Disabled' or 'Enabled') .. ' cmp', vim.log.levels.INFO)
          end,
        },
        {
          '<leader>cd',
          function()
            vim.g.autocomplete_disable = not vim.g.autocomplete_disable
            vim.notify((vim.g.autocomplete_disable and 'Disabled' or 'Enabled') .. ' autocomplete', vim.log.levels.INFO)
          end,
        },
      },
      [{ 'n', 't' }] = {
        -- Better tabs
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
        {
          '<Esc>',
          function()
            if vim.api.nvim_win_get_config(0).relative ~= '' then return '<Cmd>quit<CR>' end
            if vim.v.hlsearch == 1 then return '<Cmd>nohlsearch<CR>' end
            return '<Esc>'
          end,
          { expr = true },
        },
        { '<leader>q', vim.cmd.bdelete },
        -- Autoindent on insert/append
      },
      [{ 'n', 'v' }] = {
        { '<leader>p', '"+p' },
        { '<leader>P', '"+P' },
        { '<leader>y', '"+y' },
        { '<leader>%', '<Cmd>%y<CR>' },
        { '<leader>Y', '"+Y' },
        { '<LeftRelease>', '"*ygv' },
        { '<C-S-x>', '"+d' },
        { '<C-S-v>', '"+p' },
        { '<C-S-c>', '"+y' },
      },
      [{ 'ca' }] = {
        M.fish_style_abbr('L', 'Lazy'),
        M.fish_style_abbr('V', 'vert'),
        M.fish_style_abbr('VS', 'vert sb'),
        M.fish_style_abbr('s', 's/g<Left><Left>'),
        M.fish_style_abbr('h', 'vert h'),
        M.fish_style_abbr('w', function()
          local auto_p = 'w ++p'
          if vim.env.USER == 'root' then return auto_p end
          local prefixes = { '/etc' }
          for _, prefix in ipairs(prefixes) do
            if vim.startswith(vim.api.nvim_buf_get_name(0), prefix) then return 'SudaWrite' end
          end
          return auto_p
        end),
        M.fish_style_abbr('!', 'term'),
      },
      [{ 'v' }] = {
        { 'A', function() return vim.fn.mode() == [[\22n]] and 'A' or [[<Esc>`>a]] end, { expr = true } },
        { 'x', '"_x' },
        { 'X', '"_X' },
      },
      [{ 'i' }] = {
        -- {
        -- '<Esc>',
        -- function()
        --   local col = vim.api.nvim_win_get_cursor(0)[2]
        --   return (col < 2) and 'l<esc>' or '<esc>'
        -- end,
        --   { expr = true },
        -- },
        { '<C-CR>', '<Esc>o' },
        { '<C-S-CR>', '<Esc>O' },
      },
    }, { silent = true })
  end,
  substitute = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader>r', function() require('substitute.range').operator() end },
        { '<leader>rr', function() require('substitute.range').word() end },
      },
      [{ 'x' }] = {
        { 'r', function() require('substitute').visual() end },
        { '<leader>r', function() require('substitute.range').visual() end },
      },
    }, {}, opts)
  end,
  smart_splits = function(opts)
    return map({
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
    }, { silent = true }, opts)
  end,
  treesj = function(opts)
    return map({
      [{ 'n' }] = { { 'gJ', vim.cmd.TSJToggle, { desc = 'Split/join line' } } },
    }, {}, opts)
  end,
  lsp = function(bufnr)
    local lsp = vim.lsp.buf
    map({
      [{ 'n' }] = {
        { 'gD', lsp.declaration, { desc = '(LSP) Get declaration' } },
        { 'gd', lsp.definition, { desc = '(LSP) Get definition' } },
        -- { 'K',          lsp.hover,                   { desc = '(LSP) Get definition' } },
        { 'gi', lsp.implementation, { desc = '(LSP) Get implementation' } },
        { 'gk', lsp.signature_help, { desc = '(LSP) Get signature help' } },
        { '<leader>wa', lsp.add_workspace_folder, { desc = '(LSP) Add workspace folder' } },
        { '<leader>wr', lsp.remove_workspace_folder, { desc = '(LSP) Remove workspace folder' } },
        { '<leader>gi', lsp.incoming_calls, { desc = '(LSP) Get incoming calls' } },
        { '<leader>go', lsp.outgoing_calls, { desc = '(LSP) Get outgoing calls' } },
        {
          '<leader>wl',
          function() vim.print(lsp.list_workspace_folders()) end,
          { desc = '(LSP) Get workspace folders' },
        },
        { '<leader>D', lsp.type_definition, { desc = '(LSP) Get type' } },
        { 'ga', lsp.code_action, { desc = '(LSP) Get code actions' } },
        { 'gr', lsp.references, { desc = '(LSP) Get references' } },
        -- {
        --   '<leader>f',
        --   function()
        --     local client_names = vim.tbl_map(
        --       function(client) return client.name end,
        --       vim.lsp.get_clients({ bufnr = 0 })
        --     )
        --     vim.ui.select(client_names, { prompt = 'Select a client to format current buffer:' }, function(client_name)
        --       if vim.tbl_contains(client_names, client_name) then
        --         local choice = client_name
        --         require('conform').format({ filter = function(client) return client.name == choice end })
        --       else
        --         vim.notify('invalid client name', vim.log.levels.INFO)
        --       end
        --     end)
        --   end,
        --   { desc = '(LSP) Format (choose)' },
        -- },
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
        { '<leader>b', dap.toggle_breakpoint },
        { '<leader>ds', dap.stop },
        { '<leader>db', dap.run_to_cursor },
        { '<leader>dc', dap.disconnect },
        { '<leader>dk', dap.up },
        { '<leader>de', dap.set_exception_breakpoints },
        { '<leader>dj', dap.down },

        { '<F9>', dap.continue },
        { '<F11>', dap.step_into },
        { '<S-F11>', dap.step_out },
        { '<F10>', dap.step_over },
      },
    })
  end,
  dapgo = function()
    local dap_go = require('dap-go')
    map({
      [{ 'n' }] = {
        { '<localleader>dt', dap_go.debug_test },
        { '<localleader>dlt', dap_go.debug_last_test },
      },
    })
  end,
  dapui = function()
    local ui = require('dapui')
    map({
      [{ 'n' }] = {
        { '<S-F5>', ui.toggle },
        { '<S-F5>', function() require('dapui').eval(nil, { enter = true }) end },
        { '<S-F6>', ui.close },
        { '<S-F7>', ui.float_element },
      },
    })
  end,
  diagnostics = function()
    local diag = vim.diagnostic
    map({
      [{ 'n' }] = {
        { '<leader>k', diag.open_float, { desc = 'Floating Diagnostics' } },
        -- { '[d', diag.goto_prev, { desc = 'Previous diagnostic' } },
        -- { ']d', diag.goto_next, { desc = 'Next diagnostic' } },
        { '<leader>q', diag.setloclist, { desc = 'Add diagnostics to location list' } },
      },
    })
  end,
  incremental_rename = function()
    map({
      [{ 'n' }] = {
        {
          '<leader>rn',
          function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
          { expr = true, desc = 'rename (incrementally)' },
        },
        {
          '<leader>Rn',
          function() return ':IncRename ' .. vim.fn.expand('<cWORD>') end,
          { expr = true, desc = 'rename (incrementally)' },
        },
        {
          '<F6>',
          function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
          { expr = true, desc = 'rename (incrementally)' },
        },
        {
          '<Shift-F6>',
          function() return ':IncRename ' .. vim.fn.expand('<cWORD>') end,
          { expr = true, desc = 'rename (incrementally)' },
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
      },
    }, { remap = false, silent = true }, opts)
  end,
  marks = function(opts)
    local normal = { 'n' }
    local keymaps = {
      [normal] = {
        { 'm', '<Plug>(Marks-set)' },
        { 'm,', '<Plug>(Marks-setnext)' },
        { 'm;', '<Plug>(Marks-toggle)' },
        { 'dm', '<Plug>(Marks-delete)' },
        { 'dm-', '<Plug>(Marks-deleteline)' },
        { 'dm<Space>', '<Plug>(Marks-deletebuf)' },
        { 'm:', '<Plug>(Marks-preview)' },
        { 'm]', '<Plug>(Marks-next)' },
        { 'm[', '<Plug>(Marks-prev)' },
        { 'dm=', '<Plug>(Marks-delete-bookmark)' },
        { 'm}', '<Plug>(Marks-next-bookmark)' },
        { 'm{', '<Plug>(Marks-prev-bookmark)' },
      },
    }
    for i = 0, 9 do
      vim.list_extend(keymaps[normal], {
        { 'm' .. i, '<Plug>(Marks-set-bookmark' .. i .. ')' },
        { 'dm' .. i, '<Plug>(Marks-delete-bookmark' .. i .. ')' },
        { 'm}' .. i, '<Plug>(Marks-next-bookmark' .. i .. ')' },
        { 'm{' .. i, '<Plug>(Marks-prev-bookmark' .. i .. ')' },
      })
    end
    return map(keymaps, {}, opts)
  end,
  mini = function()
    return map({
      [{ 'n' }] = {
        { 'yss', 'ys_', { remap = true } },
      },
      [{ 'x' }] = {
        { 'S', ":<C-u>lua MiniSurround.add('visual')<CR>", { silent = true } },
      },
    })
  end,
  dial = function(opts)
    return map({
      [{ 'n' }] = {
        { '<C-a>', function() require('dial.map').manipulate('increment', 'normal') end },
        { '<C-x>', function() require('dial.map').manipulate('decrement', 'normal') end },
        { 'g<C-a>', function() require('dial.map').manipulate('increment', 'gnormal') end },
        { 'g<C-x>', function() require('dial.map').manipulate('decrement', 'gnormal') end },
      },
      [{ 'v' }] = {
        { '<C-a>', function() require('dial.map').manipulate('increment', 'visual') end },
        { '<C-x>', function() require('dial.map').manipulate('decrement', 'visual') end },
        { 'g<C-a>', function() require('dial.map').manipulate('increment', 'visual') end },
        { 'g<C-a>', function() require('dial.map').manipulate('decrement', 'visual') end },
      },
    }, {}, opts)
  end,
  telescope = function(opts)
    return map({
      [{ 'n' }] = {
        {
          '<CR><CR>',
          function() require('telescope.builtin').builtin(require('telescope.themes').get_ivy()) end,
          { desc = '(TS) Telescope', remap = false },
        },
        { '<leader><space>', function() require('telescope.builtin').buffers() end, { desc = '(TS) Buffers' } },
        { '<CR>f', function() require('telescope.builtin').find_files() end, { desc = '(TS) Find files' } },
        {
          '<CR>/',
          function() require('telescope.builtin').current_buffer_fuzzy_find() end,
          { desc = '(TS) Fuzzy find in buffer' },
        },
        { '<CR>h', function() require('telescope.builtin').help_tags() end, { desc = '(TS) Neovim help' } },
        { '<CR>t', function() require('telescope.builtin').tags() end, { desc = '(TS) Tags' } },
        { '<CR>d', function() require('telescope.builtin').grep_string() end, { desc = '(TS) grep current string' } },
        { '<CR>p', function() require('telescope.builtin').live_grep() end, { desc = '(TS) live grep a string' } },
        {
          '<CR>o',
          function() require('telescope.builtin').tags({ only_current_buffer = true }) end,
          { desc = '(TS) Tags in buffer' },
        },
        { '<CR>?', function() require('telescope.builtin').oldfiles() end, { desc = '(TS) Oldfiles' } },
        { '<CR>b', '<Cmd>Telescope file_browser<CR>', { desc = '(TS) Browse files' } },
      },
    }, {}, opts)
  end,
  fzf = function(opts)
    return map({
      [{ 'n' }] = {
        {
          '<leader><CR>',
          function() require('fzf-lua').builtin() end,
          { desc = '(FZF) Telescope', remap = false },
        },
        { '<leader><space>', function() require('fzf-lua').buffers() end, { desc = '(FZF) Buffers' } },
        { '<leader>ff', function() require('fzf-lua').files() end, { desc = '(FZF) Find files' } },
        { '<leader>fd', function() require('fzf-lua').diagnostics_workspace() end, { desc = '(FZF) Find files' } },
        {
          '<leader>f/',
          function() require('fzf-lua').current_buffer_fuzzy_find() end,
          { desc = '(FZF) Fuzzy find in buffer' },
        },
        { '<leader>fh', function() require('fzf-lua').help_tags() end, { desc = '(FZF) Neovim help' } },
        { '<leader>fg', function() require('fzf-lua').live_grep() end, { desc = '(FZF) live grep a string' } },
        {
          '<leader>fo',
          function() require('fzf-lua').tags({ only_current_buffer = true }) end,
          { desc = '(FZF) Tags in buffer' },
        },
        { '<leader>f?', function() require('fzf-lua').oldfiles() end, { desc = '(FZF) Oldfiles' } },
      },
    }, {}, opts)
  end,
  neotree = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader>e', '<Cmd>Neotree toggle left reveal_force_cwd<CR>', { desc = 'Toggle Neo-tree (left)' } },
        {
          '<leader>ws',
          '<Cmd>Neotree source=document_symbols toggle right<CR>',
          { desc = 'Toggle Neo-tree (symbols, right)' },
        },
        {
          '<leader>gf',
          '<Cmd>Neotree float reveal_file=<cfile> reveal_force_cwd<cr>',
          { desc = 'Popup Neo-tree for file under cursor' },
        },
      },
    }, {}, opts)
  end,
  yanky = function(opts)
    return map({
      [{ 'n', 'x' }] = {
        { 'p', '<Plug>(YankyPutAfter)' },
        { 'P', '<Plug>(YankyPutBefore)' },
        { 'gp', '<Plug>(YankyGPutAfter)' },
        { 'gP', '<Plug>(YankyGPutBefore)' },
        { '<c-n>', '<Plug>(YankyCycleForward)' },
        { '<c-p>', '<Plug>(YankyCycleBackward)' },
        { ']p', '<Plug>(YankyPutIndentAfterLinewise)' },
        { '[p', '<Plug>(YankyPutIndentBeforeLinewise)' },
        { ']P', '<Plug>(YankyPutIndentAfterLinewise)' },
        { '[P', '<Plug>(YankyPutIndentBeforeLinewise)' },

        { '>p', '<Plug>(YankyPutIndentAfterShiftRight)' },
        { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)' },
        { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)' },
        { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)' },

        { '=p', '<Plug>(YankyPutAfterFilter)' },
        { '=P', '<Plug>(YankyPutBeforeFilter)' },
      },
    }, { remap = true }, opts)
  end,
  leap = function(opts)
    return map({
      [{ 'n', 'o' }] = {
        { 's', '<Plug>(leap-forward-to)', { desc = 'Leap forward to' } },
        { 'S', '<Plug>(leap-backward-to)', { desc = 'Leap backward to' } },
        { 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from window' } },
        { 'gs', '<Plug>(leap-cross-window)', { desc = 'Leap from window' } },
      },
      [{ 'x', 'o' }] = {
        { 'x', '<Plug>(leap-forward-till)', { desc = 'Leap forward till' } },
        { 'X', '<Plug>(leap-backward-till)', { desc = 'Leap backward till' } },
      },
    }, {}, opts)
  end,
  heirline = function()
    map({
      [{ 'n' }] = {
        {
          'gbp',
          function()
            local tabline = require('heirline').tabline
            ---@diagnostic disable-next-line: undefined-field
            local buflist = tabline._buflist[1]
            buflist._picker_labels = {}
            buflist._show_picker = true
            vim.cmd.redrawtabline()
            local bufnr = buflist._picker_labels[vim.fn.getcharstr()]
            if bufnr then vim.api.nvim_win_set_buf(0, bufnr) end
            buflist._show_picker = false
            vim.cmd.redrawtabline()
            vim.cmd.redraw()
          end,
          { expr = true },
        },
      },
    })
  end,
  flash = function(opts)
    return map({
      [{ 'n' }] = {
        { 's', function() require('flash').jump() end, { desc = 'Flash' } },
        { 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' } },
      },
      [{ 'c' }] = { { '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' } } },
      [{ 'o', 'x' }] = {
        { 'R', function() require('flash').treesitter_search() end, { desc = 'Flash Treesitter Search' } },
      },
      [{ 'o' }] = { { 'r', function() require('flash').remote() end, { desc = 'Remote Flash' } } },
    }, {}, opts)
  end,
  trouble = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader>t', '<Cmd>Trouble<CR>', { desc = 'Trouble' } },
      },
    }, {}, opts)
  end,
  gesture = function(opts)
    return map({
      [{ 'n' }] = {
        { '<LeftDrag>', function() require('gesture').draw() end, { silent = true } },
        { '<LeftRelease>', function() require('gesture').finish() end, { silent = true } },
      },
    }, {}, opts)
  end,
  hover = function(opts)
    return map({
      [{ 'n' }] = {
        { 'K', function() require('hover').hover() end, { desc = 'hover.nvim' } },
        { 'gK', function() require('hover').hover_select() end, { desc = 'hover.nvim (select)' } },
        { '<MouseMove>', function() require('hover').hover_mouse() end, { desc = 'hover.nvim (mouse)' } },
      },
    }, {}, opts)
  end,
}

-- Other random plugin-specific mapping tables go here: --

M.cmp = {
  insert = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    return cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      ['<S-CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
  end,
  cmdline = function() return require('cmp').mapping.preset.cmdline({}) end,
}

return M

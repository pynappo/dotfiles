return {
  'echasnovski/mini.nvim',
  init = function()
    -- package.preload['nvim-web-devicons'] = function()
    --   require('mini.icons').mock_nvim_web_devicons()
    --   return package.loaded['nvim-web-devicons']
    -- end
  end,
  config = function()
    local user_command = vim.api.nvim_create_user_command
    local extra = require('mini.extra')
    local keymaps = require('pynappo.keymaps')
    -- require('mini.pairs').setup()
    require('mini.move').setup({
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<C-S-h>',
        right = '<C-S-l>',
        down = '<C-S-j>',
        up = '<C-S-k>',

        -- Move current line in Normal mode
        line_left = '<C-S-h>',
        line_right = '<C-S-l>',
        line_down = '<C-S-j>',
        line_up = '<C-S-k>',
      },
    })
    local mini_bufremove = require('mini.bufremove')
    mini_bufremove.setup()
    local bd = function() mini_bufremove.delete() end
    user_command('Bdelete', bd, {})
    user_command('BD', bd, {})
    require('mini.sessions').setup({
      -- Whether to read latest session if Neovim opened without file arguments
      autoread = false,

      -- Whether to write current session before quitting Neovim
      autowrite = true,

      -- File for local session (use `''` to disable)
      file = 'Session.vim',

      -- Whether to force possibly harmful actions (meaning depends on function)
      force = { read = false, write = true, delete = false },

      -- Hook functions for actions. Default `nil` means 'do nothing'.
      hooks = {
        -- Before successful action
        pre = { read = nil, write = nil, delete = nil },
        -- After successful action
        post = { read = nil, write = nil, delete = nil },
      },

      -- Whether to print session path after action
      verbose = { read = true, write = true, delete = true },
    })
    require('mini.hipatterns').setup()
    require('mini.align').setup({
      mappings = {
        start = '<leader>a',
        start_with_preview = '<leader>A',
      },
    })
    require('mini.surround').setup({
      custom_surroundings = nil,
      highlight_duration = 500,
      mappings = keymaps.mini.surround,
      n_lines = 30,
      respect_selection_type = true,
      search_method = 'cover',
      -- Whether to disable showing non-error feedback
      silent = false,
    })
    -- require('mini.files').setup({
    --   -- Customization of shown content
    --   content = {
    --     -- Predicate for which file system entries to show
    --     filter = nil,
    --     -- What prefix to show to the left of file system entry
    --     prefix = nil,
    --     -- In which order to show file system entries
    --     sort = nil,
    --   },
    --
    --   -- Module mappings created only inside explorer.
    --   -- Use `''` (empty string) to not create one.
    --   mappings = {
    --     close = 'q',
    --     go_in = 'l',
    --     go_in_plus = 'L',
    --     go_out = 'h',
    --     go_out_plus = 'H',
    --     reset = '<BS>',
    --     reveal_cwd = '@',
    --     show_help = 'g?',
    --     synchronize = '=',
    --     trim_left = '<',
    --     trim_right = '>',
    --   },
    -- })

    vim.keymap.del('x', keymaps.mini.surround.add)
    -- local indentscope = require('mini.indentscope')
    -- indentscope.setup({
    --   draw = {
    --     animation = indentscope.gen_animation.quadratic({ easing = 'out', duration = 10, unit = 'step' }),
    --   },
    --   options = { try_as_border = true },
    --   symbol = '󰇙',
    -- })
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if vim.tbl_contains({ 'nofile', 'help' }, vim.bo[args.buf].buftype) then
          vim.b[args.buf].miniindentscope_disable = true
        end
      end,
    })
    local trailspace = require('mini.trailspace')
    trailspace.setup()
    local command_map = {
      whitespace = trailspace.trim,
      last_lines = trailspace.trim_last_lines,
      all = function()
        trailspace.trim()
        trailspace.trim_last_lines()
      end,
    }
    user_command(
      'Trim',
      function(args) (command_map[args.args] or command_map.all)() end,
      { nargs = '?', complete = function() return vim.tbl_keys(command_map) end }
    )
    keymaps.setup.mini()
    require('pynappo.theme').overrides.all.vim_highlights.MiniIndentscopeSymbol = 'guifg=#666666 gui=nocombine'
    require('pynappo.theme').overrides.all.vim_highlights.MiniTrailSpace = 'guifg=#555555 gui=undercurl,nocombine'
    -- local clue = require('mini.clue')
    -- clue.setup({
    --   triggers = {
    --     -- Leader triggers
    --     { mode = 'n', keys = '<Leader>' },
    --     { mode = 'x', keys = '<Leader>' },
    --
    --     -- Built-in completion
    --     { mode = 'i', keys = '<C-x>' },
    --
    --     -- `g` key
    --     { mode = 'n', keys = 'g' },
    --     { mode = 'x', keys = 'g' },
    --
    --     -- Marks
    --     { mode = 'n', keys = "'" },
    --     { mode = 'n', keys = '`' },
    --     { mode = 'x', keys = "'" },
    --     { mode = 'x', keys = '`' },
    --
    --     -- Registers
    --     { mode = 'n', keys = '"' },
    --     { mode = 'x', keys = '"' },
    --     { mode = 'i', keys = '<C-r>' },
    --     { mode = 'c', keys = '<C-r>' },
    --
    --     -- Window commands
    --     { mode = 'n', keys = '<C-w>' },
    --
    --     -- `z` key
    --     { mode = 'n', keys = 'z' },
    --     { mode = 'x', keys = 'z' },
    --   },
    --
    --   clues = {
    --     -- Enhance this by adding descriptions for <Leader> mapping groups
    --     clue.gen_clues.builtin_completion(),
    --     clue.gen_clues.g(),
    --     clue.gen_clues.marks(),
    --     clue.gen_clues.registers(),
    --     clue.gen_clues.windows(),
    --     clue.gen_clues.z(),
    --   },
    -- })
    local map = require('mini.map')
    map.setup({
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.gitsigns(),
        map.gen_integration.diagnostic(),
      },
      symbols = {
        -- Encode symbols. See `:h MiniMap.config` for specification and
        -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
        -- Default: solid blocks with 3x2 resolution.
        encode = nil,

        -- Scrollbar parts for view and line. Use empty string to disable any.
        scroll_line = '█',
        scroll_view = '┃',
      },

      -- Window options
      window = {
        -- Whether window is focusable in normal way (with `wincmd` or mouse)
        focusable = false,

        -- Side to stick ('left' or 'right')
        side = 'right',

        -- Whether to show count of multiple integration highlights
        show_integration_count = true,

        -- Total width
        width = 10,

        -- Value of 'winblend' option
        winblend = 25,

        -- Z-index
        zindex = 10,
      },
    })
    user_command('MiniMapToggle', function() map.toggle() end, {})
    require('mini.pick').setup({
      -- Delays (in ms; should be at least 1)
      delay = {
        -- Delay between forcing asynchronous behavior
        async = 10,

        -- Delay between computation start and visual feedback about it
        busy = 50,
      },

      -- Keys for performing actions. See `:h MiniPick-actions`.
      mappings = {
        caret_left = '<Left>',
        caret_right = '<Right>',

        choose = '<CR>',
        choose_in_split = '<C-s>',
        choose_in_tabpage = '<C-t>',
        choose_in_vsplit = '<C-v>',
        choose_marked = '<M-CR>',

        delete_char = '<BS>',
        delete_char_right = '<Del>',
        delete_left = '<C-u>',
        delete_word = '<C-w>',

        mark = '<C-x>',
        mark_all = '<C-a>',

        move_down = '<C-n>',
        move_start = '<C-g>',
        move_up = '<C-p>',

        paste = '<C-r>',

        refine = '<C-Space>',
        refine_marked = '<M-Space>',

        scroll_down = '<C-f>',
        scroll_left = '<C-h>',
        scroll_right = '<C-l>',
        scroll_up = '<C-b>',

        stop = '<Esc>',

        toggle_info = '<S-Tab>',
        toggle_preview = '<Tab>',
      },

      -- General options
      options = {
        -- Whether to show content from bottom to top
        content_from_bottom = false,

        -- Whether to cache matches (more speed and memory on repeated prompts)
        use_cache = true,
      },

      -- Source definition. See `:h MiniPick-source`.
      source = {
        items = nil,
        name = nil,
        cwd = nil,

        match = nil,
        show = nil,
        preview = nil,

        choose = nil,
        choose_marked = nil,
      },

      -- Window related options
      window = {
        -- Float window config (table or callable returning it)
        config = nil,

        -- String to use as cursor in prompt
        prompt_cursor = '▏',

        -- String to use as prefix in prompt
        prompt_prefix = '> ',
      },
    })
    local extra_ai = extra.gen_ai_spec
    require('mini.ai').setup({
      custom_textobjects = {
        -- ['%'] = extra_ai.buffer(),
        D = extra_ai.diagnostic(),
        I = extra_ai.indent(),
        L = extra_ai.line(),
        N = extra_ai.number(),
      },
    })
    local diff = require('mini.diff')
    diff.setup({
      -- source = {
      --   -- diff.gen_source.save(),
      -- },
    })
    user_command('DiffOverlay', function() diff.toggle_overlay(0) end, {})
    user_command('DiffQf', function() vim.fn.setqflist(diff.export('qf')) end, {})
  end,
}

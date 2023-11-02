local keymaps, theme = require('pynappo.keymaps'), require('pynappo.theme')
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      local colors = {
        { 'Red', '#3b2727' },
        { 'Yellow', '#464431' },
        { 'Green', '#31493a' },
        { 'Blue', '#273b4b' },
        { 'Indigo', '#303053' },
        { 'Violet', '#403040' },
      }
      require('ibl').setup({
        exclude = {
          filetypes = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
        },
        indent = {
          highlight = theme.set_rainbow_colors('IndentBlanklineLevel', colors),
        },
        scope = {
          enabled = false,
          show_start = true,
        },
      })
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
      window = { border = 'single' },
      triggers_nowait = { '<leader>', 'g' },
    },
  },
  { 'folke/trouble.nvim', config = true, cmd = 'Trouble', keys = keymaps.setup.trouble({ lazy = true }) },
  { 'folke/which-key.nvim', event = 'VeryLazy', opts = {window = {border = 'single'}} },
  { 'folke/trouble.nvim', config = true, cmd = 'Trouble', keys = keymaps.setup.trouble({lazy = true})},
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { highlight = { keyword = 'fg', after = '' } } },
  { 'folke/which-key.nvim', enabled = false, event = 'VeryLazy', opts = {window = {border = 'single'}} },
  { 'folke/trouble.nvim', config = true, cmd = 'Trouble', keys = keymaps.setup.trouble({lazy = true})},
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { highlight = { keyword = 'fg', after = '' } } },
  {
    'RRethy/vim-illuminate',
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      require('illuminate').configure({
        filetypes_denylist = {
          'dropbar_menu',
        },
      })
    end,
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup({
        override_lens = function(render, pos_list, nearest, idx, rel_idx)
          local sfw = vim.v.searchforward == 1
          local indicator, text, chunks
          local abs_rel_idx = math.abs(rel_idx)
          if abs_rel_idx > 1 then
            indicator = ('%d %s'):format(abs_rel_idx, sfw ~= (rel_idx > 1) and '' or '')
          elseif abs_rel_idx == 1 then
            indicator = sfw ~= (rel_idx == 1) and '' or ''
          end

          local lnum, col = unpack(pos_list[idx])
          if nearest then
            local cnt = #pos_list
            if indicator then
              text = ('%s %d'):format(indicator, idx)
            else
              text = ('%d/%d'):format(idx, cnt)
            end
            chunks = {
              { '    ', 'HlSearchLensNearIcon' },
              { ' ', 'Ignore' },
              { '', 'HlSearchLensNearSurround' },
              { text, 'HlSearchLensNear' },
              { ' ', 'HlSearchLensNearSurround' },
            }
          else
            text = indicator
            chunks = {
              { '    ', 'Ignore' },
              { '', 'HlSearchLensSurround' },
              { text, 'HlSearchLens' },
              { '', 'HlSearchLensSurround' },
            }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end,
      })

      local nvim_get_hl_hex = require('pynappo.utils').nvim_get_hl_hex
      local overrides = require('pynappo.theme').overrides
      for _, hl in ipairs({ 'HlSearchLensNear', 'HlSearchLens' }) do
        overrides.all.nvim_highlights[hl .. 'Surround'] = { fg = nvim_get_hl_hex(0, { name = hl, link = false }).bg }
        overrides.all.nvim_highlights[hl .. 'Icon'] =
          { fg = nvim_get_hl_hex(0, { name = hl, link = false }).fg, bold = true }
      end
    end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = keymaps.setup.hlslens({ lazy = true }),
  },
  {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'neo-tree' },
        winblend = 75,
        signs_on_startup = {
          'conflicts',
          'spell',
          'marks',
          'loclist',
          'diagnostics',
          'search',
          'quickfix',
          'trail',
        },
        base = 'right',
      })
      theme.overrides.all.vim_highlights.ScrollViewMarks = 'guibg=NONE'
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = {
          enabled = true,
        },
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        callback = function() require('nvim-lightbulb').update_lightbulb() end,
      })
    end,
  },
  {
    'glacambre/firenvim',
    build = function() vim.fn['firenvim#install'](0) end,
  },
}

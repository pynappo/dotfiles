local keymaps = require('pynappo.keymaps')
---@type LazySpec[]
return {
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    event = 'BufReadPre',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').opts.special_keys.prev_target = '<bs>'
      require('leap').opts.special_keys.prev_group = '<bs>'
      require('leap.user').set_repeat_keys('<cr>', '<bs>')
    end,
    keys = keymaps.setup.leap({ lazy = true }),
  },
  -- { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = 'TSJToggle',
    config = function() require('treesj').setup({ use_default_keymaps = false }) end,
    keys = keymaps.setup.treesj({ lazy = true }),
  },
  {
    'monaqa/dial.nvim',
    event = 'VeryLazy',
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.hexcolor.new({ case = 'lower' }),
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.case.new({
            types = { 'snake_case', 'kebab-case', 'camelCase', 'PascalCase', 'SCREAMING_SNAKE_CASE' },
            cyclic = true,
          }),
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.case.new({
            types = { 'snake_case', 'kebab-case', 'camelCase', 'PascalCase', 'SCREAMING_SNAKE_CASE' },
            cyclic = true,
          }),
        },
      })
    end,
    keys = keymaps.setup.dial({ lazy = true }),
  },
  {
    'gbprod/substitute.nvim',
    event = 'VeryLazy',
    opts = {
      on_substitute = nil,
      yank_substituted_text = false,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        prefix = 's',
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        motion1 = false,
        motion2 = false,
        suffix = '',
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
      },
    },
    keys = keymaps.setup.substitute({ lazy = true }),
  },
  {
    'abecodes/tabout.nvim',
    event = 'InsertEnter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      act_as_tab = true, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      default_shift_tab = '<C-d>', -- reverse shift default action,
      enable_backwards = true, -- well ...
      completion = true, -- if the tabkey is used in a completion pum
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
      },
      ignore_beginning = false, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
      exclude = {}, -- tabout will ignore these filetypes
    },
    config = function(self, opts)
      require('tabout').setup(opts)
      vim.keymap.set('i', '<Tab>', '<Plug>(Tabout)', { silent = true })
      vim.keymap.set('i', '<S-Tab>', '<Plug>(TaboutBack)', { silent = true })
    end,
  },
}

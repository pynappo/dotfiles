local keymaps = require('pynappo.keymaps')
local github = require('pynappo.utils').repourl.github
vim.pack.add({
  'https://codeberg.org/andyg/leap.nvim',
  github('kylechui/nvim-surround'),
  github('Wansmer/treesj'),
  github('nvim-treesitter/nvim-treesitter'),
  github('monaqa/dial.nvim'),
  github('abecodes/tabout.nvim'),
})
require('leap').opts.special_keys.prev_target = '<bs>'
require('leap').opts.special_keys.prev_group = '<bs>'
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
keymaps.setup.treesj()
require('treesj').setup({ use_default_keymaps = false })
require('nvim-surround').setup()
---@diagnostic disable-next-line: missing-fields
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
keymaps.setup.dial()
require('tabout').setup({
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
})
vim.keymap.set('i', '<Tab>', '<Plug>(Tabout)', { silent = true })
vim.keymap.set('i', '<S-Tab>', '<Plug>(TaboutBack)', { silent = true })

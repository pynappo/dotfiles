---@diagnostic disable: missing-fields
local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('AckslD/nvim-FeMaco.lua'),
  github('wallpants/github-preview.nvim'),
  -- github('OXY2DEV/markview.nvim'),
})
local gpreview = require('github-preview')
gpreview.setup({})

local fns = gpreview.fns
vim.keymap.set('n', '<leader>mpt', fns.toggle)
vim.keymap.set('n', '<leader>mps', fns.single_file_toggle)
vim.keymap.set('n', '<leader>mpd', fns.details_tags_toggle)
require('femaco').setup()

-- local presets = require('markview.presets')

-- ---@type markview.config.markdown.headings
-- require('markview').setup({
--   typst = {
--     enable = false,
--   },
--   markdown = {
--     headings = {
--
--       ---+ ${conf, Glow-like headings}
--       enable = true,
--       shift_width = 0,
--
--       heading_1 = {
--         style = 'label',
--         sign = false,
--
--         padding_left = ' ',
--         padding_right = ' ',
--         icon = '󰼏 ',
--         hl = 'MarkviewHeading1',
--       },
--       heading_2 = {
--         style = 'label',
--         sign = false,
--
--         padding_left = ' ',
--         padding_right = ' ',
--         icon = '󰎨 ',
--         hl = 'MarkviewHeading2',
--       },
--       heading_3 = {
--         style = 'label',
--
--         padding_left = ' ',
--         padding_right = ' ',
--         icon = '󰼑 ',
--         hl = 'MarkviewHeading3',
--       },
--       heading_4 = {
--         style = 'label',
--
--         padding_left = ' ',
--         padding_right = ' ',
--         icon = '󰎲 ',
--         hl = 'MarkviewHeading4',
--       },
--       heading_5 = {
--         style = 'label',
--
--         padding_left = ' ',
--         padding_right = ' ',
--         icon = '󰼓 ',
--         hl = 'MarkviewHeading5',
--       },
--       heading_6 = {
--         style = 'label',
--
--         padding_left = ' ',
--         padding_right = ' ',
--         icon = '󰎴 ',
--         hl = 'MarkviewHeading6',
--       },
--     },
--     horizontal_rules = presets.horizontal_rules.thin,
--     code_blocks = {
--       style = 'block',
--       label_direction = 'left',
--       sign = false,
--       pad_amount = 0,
--       ---@diagnostic disable-next-line: assign-type-mismatch
--       min_width = function(buf)
--         local textwidth = vim.bo[buf].textwidth
--
--         if textwidth == 0 then
--           return vim.o.textwidth
--         else
--           return textwidth
--         end
--       end,
--     },
--   },
-- })

-- install lazy.nvim, a plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- some nice-to-have settings
vim.cmd.colorscheme('habamax')
local o = vim.o
local opt = vim.opt
o.smartcase = true
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true
o.timeoutlen = 2000
o.list = true
opt.listchars = {
  lead = '.',
  eol = '󱞣',
}
vim.g.mapleader = ' '
vim.opt.relativenumber = true
vim.opt.number = true
local function l_function(fn)
  assert(
    type(fn) == 'function',
    ('Error expected type <function> as argument for l_function, got <%s>'):format(type(fn))
  )
  local self = {}
  self.__type = '<l_function'
  self.src = fn
  return self
end
local keymaps = {
  nv = {
    ['<leader>k'] = { l_function(function() vim.print('hi') end) },
  },
}
for modestr, maps in pairs(keymaps) do
  assert(type(modestr) == 'string', 'Error! Invalid keymap argument(should be string')
  local modes = {}
  for char in modestr:gmatch('[%a!]') do
    modes[#modes + 1] = char
  end
  if #modes == 0 then goto continue end
  for key, map in pairs(maps) do
    local config = map[2] or map['config'] or map['settings'] or {}
    local cd = map[1] or map['fn'] or map['src'] or map['func'] or (map.__type and map)
    vim.print(modes, key, cd, config)
    if not vim.tbl_contains({ '<vim_cmd>', '<l_function>' }, cd.__type) then goto continue end
    if cd.__type == '<l_function>' then
      if type(cd['src']) ~= 'function' then goto local_cont end
      vim.keymap.set(modes, key, cd['src'], config)
    elseif cd.__type == '<vim_cmd>' then
      if type(cd['src']) ~= 'string' then goto local_cont end
      vim.keymap.set(modes, key, cd['src'], config)
    end
    ::local_cont::
  end
  ::continue::
end
-- setup plugins
require('lazy').setup({
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   event = { 'BufNewFile', 'BufReadPost' },
  --   build = function()
  --     if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
  --   end,
  --   cmd = 'TSUpdate',
  --   config = function()
  --     require('nvim-treesitter.configs').setup({
  --       auto_install = true,
  --       ensure_installed = {
  --         'lua',
  --         'astro',
  --         'typescript',
  --         'javascript',
  --         'tsx',
  --         'html',
  --       },
  --       highlight = {
  --         enable = true,
  --       },
  --       textsubjects = {
  --         enable = true,
  --       },
  --       indent = {
  --         enable = true,
  --       },
  --     })
  --   end,
  -- },
})

return {
  { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
  { 'AckslD/nvim-FeMaco.lua', config = function() require('femaco').setup() end },
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    config = function()
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end
  }
}

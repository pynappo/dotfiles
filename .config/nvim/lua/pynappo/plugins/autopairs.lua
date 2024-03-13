return {
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      { '$', '$', ft = { 'typst' } },
      extensions = {
        filetype = {
          p = 90,
          nft = { 'TelescopePrompt' },
          tree = true,
        },
      },
    },
  },
}

return {
  {
    "HampusHauffman/block.nvim",
    cmd = {'Block', 'BlockOn', "BlockOff"},
    opts = {
      bg = require('pynappo.utils').nvim_get_hl_hex(0, {name = 'NormalFloat'}).bg
    }
  },
}

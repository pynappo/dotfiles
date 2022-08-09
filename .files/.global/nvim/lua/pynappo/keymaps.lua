local map = vim.keymap.set
local ts = require("telescope.builtin")

-- Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local mappings = {
  ["n"] = {
    -- Telescope
    { "j", "gj" },
    { "k", "gk" },
    { "<leader><space>", ts.buffers},
    { "<leader>ff", [[ts.find_files { previewer = false }]]},
    { "<leader>fb", ts.current_buffer_fuzzy_find},
    { "<leader>fh", ts.help_tags},
    { "<leader>ft", ts.tags},
    { "<leader>fd", ts.grep_string},
    { "<leader>fp", ts.live_grep},
    { "<leader>fo", [[ts.tags { only_current_buffer = true }]]},
    { "<leader>?", ts.oldfiles},
    -- Diagnostics
    { "<leader>e", vim.diagnostic.open_float},
    { "[d", vim.diagnostic.goto_prev},
    { "]d", vim.diagnostic.goto_next},
    { "<leader>q", vim.diagnostic.setloclist},
    -- Better window navigation
    { "<C-j>", "<C-w>j" },
    { "<C-k>", "<C-w>k" },
    { "<C-h>", "<C-w>h" },
    { "<C-l>", "<C-w>l" },
    -- Neotree
    { "<leader>n", ":Neotree toggle left reveal_force_cwd<CR>" },
    { "<leader>b", ":Neotree toggle show buffers right<CR>" },
    { "<leader>g", ":Neotree float git_status<CR>" },
    { "<leader>m", ":MinimapToggle<CR>" },
    -- Better pasting
    { "p", "p=`]" },
  }
}

for mode, mapping in pairs(mappings) do
  for _, m in pairs(mapping) do
    map(mode, m[1], m[2])
  end
end



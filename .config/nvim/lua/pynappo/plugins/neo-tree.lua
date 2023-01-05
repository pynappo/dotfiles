-- If you want icons for diagnostic errors, you'll need to define them somewhere:
local keymaps = require("pynappo/keymaps")
local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function (prompt_bufnr, map)
      local actions = require "telescope.actions"
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require "telescope.actions.state"
        local selection = action_state.get_selected_entry()
        local filename = selection.filename or selection[1]
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end
  }
end

require("neo-tree").setup({
  sources = { "filesystem", "buffers", "git_status" },
  add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  close_floats_on_escape_key = true,
  default_source = "filesystem",
  sort_case_insensitive = true,
  enable_diagnostics = true,
  use_default_mappings = true,
  -- source_selector provides clickable tabs to switch between sources.
  source_selector = {
    winbar = true, -- toggle to show selector on winbar
    statusline = false, -- toggle to show selector on statusline
    show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
    -- of the top visible node when scrolled down.
    tab_labels = { -- falls back to source_name if nil
      filesystem = "  Files ",
      buffers =    "  Buffers ",
      git_status = "  Git ",
      diagnostics = " 裂Diagnostics ",
    },
    content_layout = "center", -- only with `tabs_layout` = "equal", "focus"
    tabs_layout = "equal", -- start, end, center, equal, focus
    truncation_character = "…", -- character to use when truncating the tab label
    padding = 0, -- can be int or table
    separator = { left = "▏", right= "▕" },
    show_separator_on_edge = false,
    --                       true  : |/    a    \/    b    \/    c    \|
    --                       false : |     a    \/    b    \/    c     |
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
      width = "100%",
      right_padding = 0,
    },
    modified = {
      symbol = "[+] ",
      highlight = "NeoTreeModified",
    },
    name = { use_git_status_colors = true, },
    git_status = { align = "right", },
  },
  window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
    -- possible options. These can also be functions that return these options.
    position = "left", -- left, right, top, bottom, float, current
    width = 30, -- applies to left and right positions
    height = 15, -- applies to top and bottom positions
    popup = { -- settings that apply to float position only
      size = {
        height = "80%",
        width = "50%",
      },
      position = "50%", -- 50% means center it
      -- you can also specify border here, if you want a different setting from
      -- the global popup_border_style.
    },
    mapping_options = { noremap = true, nowait = true, },
    mappings = keymaps.neotree.default,
  },
  filesystem = {
    window = { mappings = keymaps.neotree.filesystem, },
    commands = {
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require('telescope.builtin').find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
      end,
      run_command = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.api.nvim_input(": " .. path .. "<Home>")
      end,
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        if vim.fn.has('win32') == 1 then
          print("Opening " .. path .. " with Start-Process")
          vim.fn.system('start', path)
        else for _, open_cmd in pairs({'xdg-open', 'open'}) do
            if vim.fn.executable(open_cmd) == 1 then
              print("Opening " .. path .. " with " .. open_cmd)
              vim.fn.system(open_cmd, path)
              return
            end
          end
        end
      end,
    },
    bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
    cwd_target = { sidebar = "tab", current = "window" },
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
      show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
    },
    find_by_full_path_words = false,  -- `false` means it only searches the tail of a path.
    group_empty_dirs = false, -- when true, empty folders will be grouped together
    search_limit = 50, -- max number of search results when using filters
    follow_current_file = true, -- This will find and focus the file in the active buffer every time
    -- the current file is changed while the tree is open.
  },
  buffers = {
    bind_to_cwd = true,
    follow_current_file = true, -- This will find and focus the file in the active buffer every time
    -- the current file is changed while the tree is open.
    group_empty_dirs = true, -- when true, empty directories will be grouped together
    window = { mappings = keymaps.neotree.buffers, },
  },
  git_status = { window = { mappings = keymaps.neotree.git_status, }, },
})

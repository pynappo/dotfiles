-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.g.neo_tree_remove_legacy_commands = 1
-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})
local keymaps = require("pynappo/keymaps")
keymaps.setup.neotree_window()
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
  event_handlers = {
    {
      event = "file_open_requested",
      handler = function(args)
        local state = args.state
        local path = args.path
        local open_cmd = args.open_cmd or "edit"

        -- use last window if possible
        local suitable_window_found = false
        local nt = require("neo-tree")
        if nt.config.open_files_in_last_window then
          local prior_window = nt.get_prior_window()
          if prior_window > 0 then
            local success = pcall(vim.api.nvim_set_current_win, prior_window)
            suitable_window_found = success
          end
        end

        -- find a suitable window to open the file in
        if not suitable_window_found then vim.cmd(state.window.position == "right" and "wincmd t" or "wincmd w") end
        local attempts = 0
        while attempts < 4 and vim.bo.filetype == "neo-tree" do
          attempts = attempts + 1
          vim.cmd.wincmd("w")
        end
        if vim.bo.filetype == "neo-tree" then
          -- Neo-tree must be the only window, restore it's status as a sidebar
          local winid = vim.api.nvim_get_current_win()
          local width = require("neo-tree.utils").get_value(state, "window.width", 40)
          vim.cmd.vsplit(path)
          vim.api.nvim_win_set_width(winid, width)
        else
          vim.cmd(open_cmd .. " " .. path)
        end

        -- If you don't return this, it will proceed to open the file using built-in logic.
        return { handled = true }
      end
    },
  },
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
    --diagnostics = {
    --  symbols = {
    --    hint = "H",
    --    info = "I",
    --    warn = "!",
    --    error = "X",
    --  },
    --  highlights = {
    --    hint = "DiagnosticSignHint",
    --    info = "DiagnosticSignInfo",
    --    warn = "DiagnosticSignWarn",
    --    error = "DiagnosticSignError",
    --  },
    --},
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
    hijack_netrw_behavior = "disabled",
    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
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

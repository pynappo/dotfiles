return {
  'nvim-neo-tree/neo-tree.nvim',
  enabled = true,
  cmd = 'Neotree',
  branch = 'v3.x',
  dependencies = {
    'antosha417/nvim-lsp-file-operations',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      name = 'window-picker',
      event = 'VeryLazy',
      version = '2.*',
      opts = {
        -- 'statusline-winbar' | 'floating-big-letter'
        hint = 'floating-big-letter',

        -- when you go to window selection mode, status bar will show one of
        -- following letters on them so you can use that letter to select the window
        selection_chars = 'FJDKSLA;CMRUEIWOQP',

        -- This section contains picker specific configurations
        picker_config = {
          statusline_winbar_picker = {
            -- You can change the display string in status bar.
            -- It supports '%' printf style. Such as `return char .. ': %f'` to display
            -- buffer file path. See :h 'stl' for details.
            selection_display = function(char, windowid) return '%=' .. char .. '%=' end,

            -- whether you want to use winbar instead of the statusline
            -- "always" means to always use winbar,
            -- "never" means to never use winbar
            -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
            use_winbar = 'never', -- "always" | "never" | "smart"
          },

          floating_big_letter = {
            -- window picker plugin provides bunch of big letter fonts
            -- fonts will be lazy loaded as they are being requested
            -- additionally, user can pass in a table of fonts in to font
            -- property to use instead

            font = 'ansi-shadow', -- ansi-shadow |
          },
        },

        -- whether to show 'Pick window:' prompt
        show_prompt = true,

        -- prompt message to show to get the user input
        prompt_message = 'Pick window: ',

        -- if you want to manually filter out the windows, pass in a function that
        -- takes two parameters. You should return window ids that should be
        -- included in the selection
        -- EX:-
        -- function(window_ids, filters)
        --    -- folder the window_ids
        --    -- return only the ones you want to include
        --    return {1000, 1001}
        -- end
        filter_func = nil,

        -- following filters are only applied when you are using the default filter
        -- defined by this plugin. If you pass in a function to "filter_func"
        -- property, you are on your own
        filter_rules = {
          -- when there is only one window available to pick from, use that window
          -- without prompting the user to select
          autoselect_one = true,

          -- whether you want to include the window you are currently on to window
          -- selection or not
          include_current_win = false,

          -- ignore filters
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'NvimTree', 'neo-tree', 'notify', 'scrollview', 'noice' },

            -- if the file type is one of following, the window will be ignored
            buftype = { 'terminal', 'nofile' },
          },
          wo = {},
          file_path_contains = {},
          file_name_contains = {},
        },
        highlights = {
          statusline = {
            focused = {
              fg = '#ededed',
              bg = '#e35e4f',
              bold = true,
            },
            unfocused = {
              fg = '#ededed',
              bg = '#44cc41',
              bold = true,
            },
          },
          winbar = {
            focused = {
              fg = '#ededed',
              bg = '#e35e4f',
              bold = true,
            },
            unfocused = {
              fg = '#ededed',
              bg = '#44cc41',
              bold = true,
            },
          },
        },
      },
    },
    'mrbjarksen/neo-tree-diagnostics.nvim',
  },
  init = function() require('pynappo.keymaps').setup.neotree() end,
  config = function()
    local function getTelescopeOpts(state, path)
      return {
        cwd = path,
        search_dirs = { path },
        attach_mappings = function(prompt_bufnr, map)
          local actions = require('telescope.actions')
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local action_state = require('telescope.actions.state')
            local selection = action_state.get_selected_entry()
            local filename = selection.filename or selection[1]
            -- any way to open the file without triggering auto-close event of neo-tree?
            require('neo-tree.sources.filesystem').navigate(state, state.path, filename, function() vim.print('hi') end)
          end)
          return true
        end,
      }
    end
    require('neo-tree').setup(vim.tbl_deep_extend('force', {
      -- log_level = 'debug',
      -- log_to_file = true,
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      hide_root_node = true,
      add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      default_source = 'filesystem',
      sort_case_insensitive = true,
      enable_diagnostics = true,
      use_default_mappings = true,
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy' },
      -- source_selector provides clickable tabs to switch between sources.
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        statusline = false, -- toggle to show selector on statusline
        show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
        -- of the top visible node when scrolled down.
        sources = { -- falls back to source_name if nil
          { source = 'filesystem', display_name = ' 󰉓 Files ' },
          { source = 'buffers', display_name = ' 󰈙 Buffers ' },
          { source = 'git_status', display_name = ' 󰊢 Git ' },
          { source = 'diagnostics', display_name = ' 󰒡 Diagnostics ' },
        },
        content_layout = 'center', -- only with `tabs_layout` = "equal", "focus"
        tabs_layout = 'equal', -- start, end, center, equal, focus
        truncation_character = '…', -- character to use when truncating the tab label
        padding = 0, -- can be int or table
        separator = { left = '▏', right = '▕' },
        show_separator_on_edge = false,
        --                       true  : |/    a    \/    b    \/    c    \|
        --                       false : |     a    \/    b    \/    c     |
      },
      default_component_configs = {
        container = {
          enable_character_fade = true,
          width = '100%',
          right_padding = 0,
        },
        modified = {
          symbol = '[+] ',
          highlight = 'NeoTreeModified',
        },
        name = { use_git_status_colors = true },
        git_status = {
          symbols = {
            -- Change type
            added = '✚', -- NOTE: you can set any of these to an empty string to not show them
            deleted = '✖',
            modified = '',
            renamed = '󰁕',
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
          align = 'right',
        },
      },
      window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
        -- possible options. These can also be functions that return these options.
        position = 'left', -- left, right, top, bottom, float, current
        width = 30, -- applies to left and right positions
        height = 15, -- applies to top and bottom positions
        popup = { -- settings that apply to float position only
          size = {
            height = '80%',
            width = '50%',
          },
          position = '50%', -- 50% means center it
          -- you can also specify border here, if you want a different setting from
          -- the global popup_border_style.
        },
        mapping_options = { noremap = true, nowait = true },
      },
      filesystem = {
        async_directory_scan = 'never',
        hijack_netrw_behavior = 'disabled',
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
            vim.fn.setcmdline(vim.print(path), 1)
          end,
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.ui.open(path)
          end,
        },
        bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = { sidebar = 'tab', current = 'window' },
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          force_visible_in_empty_folder = true, -- when true, hidden files will be shown if the root folder is otherwise empty
          show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
        },
        find_by_full_path_words = false, -- `false` means it only searches the tail of a path.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        scan_mode = 'deep',
        search_limit = 50, -- max number of search results when using filters
        follow_current_file = {
          enabled = true,
        }, -- This will find and focus the file in the active buffer every time
        -- the current file is changed while the tree is open.
        use_libuv_file_watcher = true,
      },
      buffers = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
        }, -- This will find and focus the file in the active buffer every time
        -- the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty directories will be grouped together
        scan_mode = 'deep',
      },
    }, require('pynappo.keymaps').neotree))
    require('lsp-file-operations').setup()
  end,
}

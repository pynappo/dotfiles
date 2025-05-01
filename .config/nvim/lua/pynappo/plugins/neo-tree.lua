return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    dev = true,
    branch = 'v3.x',
    dependencies = {
      'folke/snacks.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'saifulapm/neotree-file-nesting-config',
      -- 'mrbjarksen/neo-tree-diagnostics.nvim',
    },
    init = function() require('pynappo.keymaps').setup.neotree() end,
    config = function()
      local function on_move(data) require('snacks').rename.on_rename_file(data.source, data.destination) end
      local events = require('neo-tree.events')
      require('neo-tree').setup({
        -- If a user has a sources list it will replace this one.
        -- Only sources listed here will be loaded.
        -- You can also add an external source by adding it's name to this list.
        -- The name used here must be the same name you would use in a require() call.

        log_level = 'trace',
        log_to_file = true,
        -- use_console = true,
        event_handlers = {
          { event = events.FILE_MOVED, handler = on_move },
          { event = events.FILE_RENAMED, handler = on_move },
          -- {
          --   event = events.NEO_TREE_BUFFER_ENTER,
          --   handler = function()
          --     backtrace()
          --     vim.print('bufenter')
          --     local state = require('neo-tree.sources.manager').get_state(vim.b['neo_tree_source'])
          --     require('neo-tree.sources.common.commands').toggle_preview(state)
          --   end,
          -- },
        },
        sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
        hide_root_node = true,
        add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        default_source = 'filesystem',
        sort_case_insensitive = true,
        enable_diagnostics = true,
        use_default_mappings = true,
        open_files_in_last_window = true, -- false = open files in top left window
        open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy' }, -- when opening files, do not use windows containing these filetypes or buftypes
        open_files_with_relative_path = true,
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
            { source = 'document_symbols', display_name = ' 󰊕 Symbols ' },
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
          symlink_target = {
            enabled = true,
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
          mappings = {
            ['<space>'] = {
              'toggle_node',
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ['<2-LeftMouse>'] = 'open',
            ['<cr>'] = 'open',
            -- ["<cr>"] = { "open", config = { expand_nested_files = true } }, -- expand nested file takes precedence
            ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
            ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
            ['<C-f>'] = { 'scroll_preview', config = { direction = -10 } },
            ['<C-b>'] = { 'scroll_preview', config = { direction = 10 } },
            ['l'] = 'focus_preview',
            ['S'] = 'open_split',
            -- ["S"] = "split_with_window_picker",
            ['s'] = 'open_vsplit',
            -- ["sr"] = "open_rightbelow_vs",
            -- ["sl"] = "open_leftabove_vs",
            -- ["s"] = "vsplit_with_window_picker",
            ['t'] = 'open_tabnew',
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ['w'] = 'open_with_window_picker',
            ['C'] = 'close_node',
            ['z'] = 'close_all_nodes',
            ['Z'] = 'expand_all_nodes',
            ['R'] = 'refresh',
            ['a'] = {
              'add',
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = 'none', -- "none", "relative", "absolute"
              },
            },
            ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
            ['d'] = 'delete',
            ['r'] = 'rename',
            ['y'] = 'copy_to_clipboard',
            ['x'] = 'cut_to_clipboard',
            ['p'] = 'paste_from_clipboard',
            ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ['e'] = 'toggle_auto_expand_width',
            ['q'] = 'close_window',
            ['?'] = 'show_help',
            ['<'] = 'prev_source',
            ['>'] = 'next_source',
          },
        },
        filesystem = {
          async_directory_scan = 'auto',
          hijack_netrw_behavior = 'open_current',
          commands = {
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
            focus_parent = function(state)
              local node = state.tree:get_node()
              local parent_id = node:get_parent_id()
              if not parent_id then return end
              local focused = require('neo-tree.ui.renderer').focus_node(state, parent_id)
              if not focused then require('neo-tree.sources.filesystem.commands').navigate_up(state) end
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
          window = {
            mappings = {
              ['^'] = 'focus_parent',
              ['H'] = 'toggle_hidden',
              ['/'] = 'fuzzy_finder',
              ['D'] = 'fuzzy_finder_directory',
              --["/"] = "filter_as_you_type", -- this was the default until v1.28
              ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ['f'] = 'filter_on_submit',
              ['<C-x>'] = 'clear_filter',
              ['<bs>'] = 'navigate_up',
              ['.'] = 'set_root',
              ['[g'] = 'prev_git_modified',
              [']g'] = 'next_git_modified',
              ['i'] = {
                'show_file_details',
                config = { modified_format = function() return '' end, created_format = 'relative' },
              },
              ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
              ['oc'] = { 'order_by_created', nowait = false },
              ['od'] = { 'order_by_diagnostics', nowait = false },
              ['og'] = { 'order_by_git_status', nowait = false },
              ['om'] = { 'order_by_modified', nowait = false },
              ['on'] = { 'order_by_name', nowait = false },
              ['os'] = { 'order_by_size', nowait = false },
              ['ot'] = { 'order_by_type', nowait = false },
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ['<down>'] = 'move_cursor_down',
              ['<C-n>'] = 'move_cursor_down',
              ['<up>'] = 'move_cursor_up',
              ['<C-p>'] = 'move_cursor_up',
            },
          },
        },
        buffers = {
          bind_to_cwd = true,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          }, -- This will find and focus the file in the active buffer every time
          -- the current file is changed while the tree is open.
          group_empty_dirs = true, -- when true, empty directories will be grouped together
          scan_mode = 'deep',
          show_unloaded = false, -- When working with sessions, for example, restored but unfocused buffers
          -- are mark as "unloaded". Turn this on to view these unloaded buffer.
          terminals_first = true, -- when true, terminals will be listed before file buffers
          window = {
            mappings = {
              ['<bs>'] = 'navigate_up',
              ['.'] = 'set_root',
              ['bd'] = 'buffer_delete',
              ['i'] = 'show_file_details',
              ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
              ['oc'] = { 'order_by_created', nowait = false },
              ['od'] = { 'order_by_diagnostics', nowait = false },
              ['om'] = { 'order_by_modified', nowait = false },
              ['on'] = { 'order_by_name', nowait = false },
              ['os'] = { 'order_by_size', nowait = false },
              ['ot'] = { 'order_by_type', nowait = false },
            },
          },
        },
        -- END CURRENT CONFIG
        auto_clean_after_session_restore = false, -- Automatically clean up broken neo-tree buffers saved in sessions
        enable_git_status = true,
        enable_modified_markers = true, -- Show markers for files with unsaved changes.
        enable_opened_markers = true, -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
        enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
        enable_cursor_hijack = false, -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
        git_status_async = true,
        -- These options are for people with VERY large git repos
        git_status_async_options = {
          batch_size = 1000, -- how many lines of git status results to process at a time
          batch_delay = 10, -- delay in ms between batches. Spreads out the workload to let other processes run.
          max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
          -- Anything before this will be used. The last items to be processed are the untracked files.
        },
        retain_hidden_root_indent = true, -- IF the root node is hidden, keep the indentation anyhow.
        -- This is needed if you use expanders because they render in the indent.
        -- popup_border_style is for input and confirmation dialogs.
        -- Configurtaion of floating window is done in the individual source sections.
        -- "NC" is a special style that works well with NormalNC set
        popup_border_style = 'NC', -- "double", "none", "rounded", "shadow", "single" or "solid"
        resize_timer_interval = 500, -- in ms, needed for containers to redraw right aligned and faded content
        -- set to -1 to disable the resize timer entirely
        --                           -- NOTE: this will speed up to 50 ms for 1 second following a resize
        sort_function = nil, -- uses a custom function for sorting files and directories in the tree
        use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
        -- source_selector provides clickable tabs to switch between sources.
        --
        renderers = {
          directory = {
            { 'indent' },
            { 'icon' },
            { 'current_filter' },
            {
              'container',
              content = {
                { 'name', zindex = 10 },
                {
                  'symlink_target',
                  zindex = 10,
                  highlight = 'NeoTreeSymbolicLinkTarget',
                },
                { 'clipboard', zindex = 10 },
                { 'diagnostics', errors_only = true, zindex = 20, align = 'right', hide_when_expanded = true },
                { 'git_status', zindex = 10, align = 'right', hide_when_expanded = true },
                { 'file_size', zindex = 10, align = 'right' },
                { 'type', zindex = 10, align = 'right' },
                { 'last_modified', zindex = 10, align = 'right' },
                { 'created', zindex = 10, align = 'right' },
              },
            },
          },
          file = {
            { 'indent' },
            { 'icon' },
            {
              'container',
              content = {
                {
                  'name',
                  zindex = 10,
                },
                {
                  'symlink_target',
                  zindex = 10,
                  highlight = 'NeoTreeSymbolicLinkTarget',
                },
                { 'clipboard', zindex = 10 },
                { 'bufnr', zindex = 10 },
                { 'modified', zindex = 20, align = 'right' },
                { 'diagnostics', zindex = 20, align = 'right' },
                { 'git_status', zindex = 10, align = 'right' },
                { 'file_size', zindex = 10, align = 'right' },
                { 'type', zindex = 10, align = 'right' },
                { 'last_modified', zindex = 10, align = 'right' },
                { 'created', zindex = 10, align = 'right' },
              },
            },
          },
          message = {
            { 'indent', with_markers = false },
            { 'name', highlight = 'NeoTreeMessage' },
          },
          terminal = {
            { 'indent' },
            { 'icon' },
            { 'name' },
            { 'bufnr' },
          },
        },
        nesting_rules = require('neotree-file-nesting-config').nesting_rules,
        -- Global custom commands that will be available in all sources (if not overridden in `opts[source_name].commands`)
        --
        -- You can then reference the custom command by adding a mapping to it:
        --    globally    -> `opts.window.mappings`
        --    locally     -> `opt[source_name].window.mappings` to make it source specific.
        --
        -- commands = {              |  window {                 |  filesystem {
        --   hello = function()      |    mappings = {           |    commands = {
        --     print("Hello world")  |      ["<C-c>"] = "hello"  |      hello = function()
        --   end                     |    }                      |        print("Hello world in filesystem")
        -- }                         |  }                        |      end
        --
        -- see `:h neo-tree-custom-commands-global`
        commands = {}, -- A list of functions

        git_status = {
          window = {
            mappings = {
              ['A'] = 'git_add_all',
              ['gu'] = 'git_unstage_file',
              ['ga'] = 'git_add_file',
              ['gr'] = 'git_revert_file',
              ['gc'] = 'git_commit',
              ['gp'] = 'git_push',
              ['gg'] = 'git_commit_and_push',
              ['i'] = 'show_file_details',
              ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
              ['oc'] = { 'order_by_created', nowait = false },
              ['od'] = { 'order_by_diagnostics', nowait = false },
              ['om'] = { 'order_by_modified', nowait = false },
              ['on'] = { 'order_by_name', nowait = false },
              ['os'] = { 'order_by_size', nowait = false },
              ['ot'] = { 'order_by_type', nowait = false },
            },
          },
        },
        document_symbols = {
          follow_cursor = true,
          client_filters = 'first',
          renderers = {
            root = {
              { 'indent' },
              { 'icon', default = 'C' },
              { 'name', zindex = 10 },
            },
            symbol = {
              { 'indent', with_expanders = true },
              { 'kind_icon', default = '?' },
              {
                'container',
                content = {
                  { 'name', zindex = 10 },
                  { 'kind_name', zindex = 20, align = 'right' },
                },
              },
            },
          },
          window = {
            mappings = {
              ['<cr>'] = 'jump_to_symbol',
              ['o'] = 'jump_to_symbol',
              ['A'] = 'noop', -- also accepts the config.show_path and config.insert_as options.
              ['d'] = 'noop',
              ['y'] = 'noop',
              ['x'] = 'noop',
              ['p'] = 'noop',
              ['c'] = 'noop',
              ['m'] = 'noop',
              ['a'] = 'noop',
              ['/'] = 'filter',
              ['f'] = 'filter_on_submit',
            },
          },
          custom_kinds = {
            -- define custom kinds here (also remember to add icon and hl group to kinds)
            -- ccls
            -- [252] = 'TypeAlias',
            -- [253] = 'Parameter',
            -- [254] = 'StaticMethod',
            -- [255] = 'Macro',
          },
          kinds = {
            Unknown = { icon = '?', hl = '' },
            Root = { icon = '', hl = 'NeoTreeRootName' },
            File = { icon = '󰈙', hl = 'Tag' },
            Module = { icon = '', hl = 'Exception' },
            Namespace = { icon = '󰌗', hl = 'Include' },
            Package = { icon = '󰏖', hl = 'Label' },
            Class = { icon = '󰌗', hl = 'Include' },
            Method = { icon = '', hl = 'Function' },
            Property = { icon = '󰆧', hl = '@property' },
            Field = { icon = '', hl = '@field' },
            Constructor = { icon = '', hl = '@constructor' },
            Enum = { icon = '󰒻', hl = '@number' },
            Interface = { icon = '', hl = 'Type' },
            Function = { icon = '󰊕', hl = 'Function' },
            Variable = { icon = '', hl = '@variable' },
            Constant = { icon = '', hl = 'Constant' },
            String = { icon = '󰀬', hl = 'String' },
            Number = { icon = '󰎠', hl = 'Number' },
            Boolean = { icon = '', hl = 'Boolean' },
            Array = { icon = '󰅪', hl = 'Type' },
            Object = { icon = '󰅩', hl = 'Type' },
            Key = { icon = '󰌋', hl = '' },
            Null = { icon = '', hl = 'Constant' },
            EnumMember = { icon = '', hl = 'Number' },
            Struct = { icon = '󰌗', hl = 'Type' },
            Event = { icon = '', hl = 'Constant' },
            Operator = { icon = '󰆕', hl = 'Operator' },
            TypeParameter = { icon = '󰊄', hl = 'Type' },

            -- ccls
            -- TypeAlias = { icon = ' ', hl = 'Type' },
            -- Parameter = { icon = ' ', hl = '@parameter' },
            -- StaticMethod = { icon = '󰠄 ', hl = 'Function' },
            -- Macro = { icon = ' ', hl = 'Macro' },
          },
        },
        example = {
          renderers = {
            custom = {
              { 'indent' },
              { 'icon', default = 'C' },
              { 'custom' },
              { 'name' },
            },
          },
          window = {
            mappings = {
              ['<cr>'] = 'toggle_node',
              ['<C-e>'] = 'example_command',
              ['d'] = 'show_debug_info',
            },
          },
        },
      })
    end,
  },
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
}

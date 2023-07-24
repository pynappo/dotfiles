return {
  { 'tpope/vim-fugitive', event = 'CmdlineEnter' },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
      -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
      auto_refresh = true,
      -- Value used for `--sort` option for `git branch` command
      -- By default, branches will be sorted by commit date descending
      -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
      -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
      sort_branches = "-committerdate",
      disable_builtin_notifications = false,
      -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example
      -- below will use the native fzf sorter instead.
      telescope_sorter = function()
        return require("telescope").extensions.fzf.native_fzf_sorter()
      end,
      use_magit_keybindings = false,
      -- Change the default way of opening neogit
      kind = "tab",
      -- The time after which an output console is shown for slow running commands
      console_timeout = 2000,
      -- Automatically show console if a command takes more than console_timeout milliseconds
      auto_show_console = true,
      -- Persist the values of switches/options within and across sessions
      remember_settings = true,
      -- Scope persisted settings on a per-project basis
      use_per_project_settings = true,
      -- Array-like table of settings to never persist. Uses format "Filetype--cli-value"
      --   ie: `{ "NeogitCommitPopup--author", "NeogitCommitPopup--no-verify" }`
      ignored_settings = {},
      -- Change the default way of opening the commit popup
      commit_popup = {
        kind = "split",
      },
      -- Change the default way of opening the preview buffer
      preview_buffer = {
        kind = "split",
      },
      -- Change the default way of opening popups
      popup = {
        kind = "split",
      },
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      -- Integrations are auto-detected, and enabled if available, but can be disabled by setting to "false"
      integrations = {
        telescope = true,
        diffview = true,
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        untracked = {
          folded = false
        },
        unstaged = {
          folded = false
        },
        staged = {
          folded = false
        },
        stashes = {
          folded = true
        },
        unpulled = {
          folded = true
        },
        unmerged = {
          folded = false
        },
        recent = {
          folded = true
        },
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        status = {
          -- Adds a mapping with "B" as key that does the "BranchPopup" command
          -- ["B"] = "BranchPopup",
          -- Removes the default mapping of "s"
          -- ["s"] = "",
        },
        -- Modify fuzzy-finder buffer mappings
        finder = {
          -- Binds <cr> to trigger select action
          ["<cr>"] = "select",
        }
      }
    }
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Octo',
    config = true
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
      signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_formatter = '<author>@<author_time:%Y-%m-%d>: <summary>',
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
    }
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'DiffviewOpen',
      'DiffviewLog',
      'DiffviewClose',
      'DiffviewRefresh',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
    }
  },
}

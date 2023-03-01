return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'debugloop/telescope-undo.nvim', -- debugloop is original dev
    'nvim-telescope/telescope-ui-select.nvim'
  },
  init = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('telescope-file-browser.nvim', { clear = true }),
      pattern = '*',
      callback = function()
        vim.schedule(function()
          local netrw_bufname, _
          if vim.bo[0].filetype == 'netrw' then return end
          local bufname = vim.api.nvim_buf_get_name(0)
          if vim.fn.isdirectory(bufname) == 0 then
            _, netrw_bufname = pcall(vim.fn.expand, '#:p:h')
            return
          end

          -- prevents reopening of file-browser if exiting without selecting a file
          if netrw_bufname == bufname then
            netrw_bufname = nil
            return
          else
            netrw_bufname = bufname
          end
          vim.bo[0].bufhidden = 'wipe'
          require('telescope').extensions.file_browser.file_browser({
            cwd = vim.fn.expand('%:p:h'),
          })
        end)
      end,
      once = true,
      desc = 'lazy-loaded telescope-file-browser.nvimw',
    })
  end,
  config = function()
    local ts = require('telescope')

    ts.setup({
      defaults = {
        path_display = { 'smart' },
        layout_strategy = 'flex',
        layout_config = {
          prompt_position = 'top',
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({}),
        },
        file_browser = {
          hijack_netrw = false,
        },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
    })
    ts.load_extension('fzf')
    ts.load_extension('file_browser')
    ts.load_extension('notify')
    ts.load_extension('undo')
    ts.load_extension('ui-select')
    ts.load_extension('yank_history')
  end,
  keys = require('pynappo/keymaps').setup.telescope({ lazy = true }),
}

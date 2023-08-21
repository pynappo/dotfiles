return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
  },
  opts = {
    mru = {
      ignore = function(path, ext)
        local ignore_patterns = {
          "COMMIT_EDITMSG",
          "nvim.-runtime",
          'nvim.-doc',
        }
        for _, pattern in ipairs(ignore_patterns) do
          if path:find(pattern) then return true end
        end
        return vim.tbl_contains({ "gitcommit" }, ext)
      end,
      autocd = false,
      width = 50
    },
    nvim_web_devicons = {
      enabled = true,
      highlight = true,
    }
  },
  config = function(self, opts)
    local plenary_path = require("plenary.path")
    local cwd = vim.fn.getcwd()
    local if_nil = vim.F.if_nil
    local dashboard = require("alpha.themes.dashboard")

    local function get_extension(fn)
      return vim.fn.fnamemodify(fn, ":e")
    end

    local function file_button(filename, sc, short_fn, autocd)
      short_fn = short_fn or filename
      local ico_txt
      local fb_hl = {}

      if opts.nvim_web_devicons.enabled then
        local icon, hl = require("nvim-web-devicons").get_icon(filename, get_extension(filename), { default = true })
        if hl and opts.nvim_web_devicons.highlight then table.insert(fb_hl, { hl, 0, #icon }) end
        ico_txt = icon .. "  "
      else
        ico_txt = ""
      end
      local cd_cmd = (autocd and " | cd %:p:h" or "")
      local element = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. filename .. cd_cmd .." <CR>")
      local fn_start = short_fn:match(".*[/\\]")
      if fn_start then table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt }) end
      element.opts.hl = fb_hl
      return element
    end

    --- @param start number
    --- @param dir string? optional
    --- @param items_number number? optional number of items to generate, default = 10
    local function mru(start, dir, items_number, mru_opts)
      mru_opts = mru_opts or opts.mru
      items_number = if_nil(items_number, 10)

      local oldfiles = {}
      for _, v in pairs(vim.v.oldfiles) do
        if require('pynappo.utils').is_windows then v = v:gsub('/', '\\') end
        if #oldfiles == items_number then break end
        local in_dir = not dir or vim.startswith(v, dir)
        local ignore = mru_opts.ignore(v, get_extension(v))
        if in_dir and vim.uv.fs_stat(v) and not ignore and not oldfiles[v] then
          table.insert(oldfiles, v)
          oldfiles[v] = true
        end
      end

      local tbl = {}
      for i, filename in ipairs(oldfiles) do
        local short_fn = vim.fn.fnamemodify(filename, dir and ":." or ":~")

        if #short_fn > mru_opts.width then
          short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
          if #short_fn > mru_opts.width then
            short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
          end
        end

        local shortcut = tostring(i + start - 1)

        local element = file_button(filename, shortcut, short_fn,opts.autocd)
        tbl[i] = element
      end
      return {
        type = "group",
        val = tbl,
        opts = {},
      }
    end

    local header = {
      type = "text",
      val = {
        [[                                  __]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      },
      opts = {
        position = "center",
        hl = "Type",
        -- wrap = "overflow";
      },
    }

    local section_mru = {
      type = "group",
      val = {
        {
          type = "text",
          val = "Recent files",
          opts = {
            hl = "SpecialComment",
            shrink_margin = true,
            position = "center",
          },
        },
        { type = "padding", val = 1 },
        {
          type = "group",
          val = function()
            return { mru(0, cwd, 10) }
          end,
          opts = {
            width = opts.width,
            shrink_margin = true,
          },
        },
      },
    }

    local buttons = {
      type = "group",
      val = {
        { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("<CR>f", "󰈞  Find file"),
        dashboard.button("<CR>p", "󰊄  Live grep"),
        dashboard.button("c", "  Configuration", "<cmd>Config<CR>"),
        dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
      },
      position = "center",
    }

    local config = {
      layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        section_mru,
        { type = "padding", val = 2 },
        buttons,
      },
      opts = {
        margin = 5,
        setup = function()
          vim.b.miniindentscope_disable = true
          vim.api.nvim_create_autocmd('DirChanged', {
            pattern = '*',
            group = "alpha_temp",
            callback = function ()
              cwd = vim.fn.getcwd()
              require('alpha').redraw()
            end,
          })
        end,
      },
    }

    require('alpha').setup(config)
  end,
}

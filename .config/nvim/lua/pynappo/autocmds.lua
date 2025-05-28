local autocmds = {}
local utils = require('pynappo.utils')
-- A function to create a function that creates autocmds for an augroup
function autocmds.create_wrapper(augroup_name)
  local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })
  return function(event, opts)
    opts.group = opts.group or augroup
    return vim.api.nvim_create_autocmd(event, opts)
  end,
    augroup
end

autocmds.create, autocmds.pynappo_augroup = autocmds.create_wrapper('pynappo')

if vim.g.started_by_firenvim then autocmds.create('BufEnter', { callback = function() vim.cmd.startinsert() end }) end

autocmds.create('TextYankPost', {
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
  desc = 'Highlight on yank',
})
autocmds.create('BufReadPost', {
  pattern = '*',
  desc = 'Restore cursor position',
  callback = function()
    local fn = vim.fn
    if fn.line('\'"') > 0 and fn.line('\'"') <= fn.line('$') then
      fn.setpos('.', fn.getpos('\'"'))
      -- vim.cmd.normal('zz')
      vim.cmd('silent! foldopen')
    end
  end,
})

autocmds.create('DiagnosticChanged', {
  desc = 'Update loclist',
  callback = function() vim.diagnostic.setloclist({ open = false }) end,
})

local exrc_names = {
  '.nvim.lua',
  '.nvimrc',
  '.exrc',
}
autocmds.create('DirChanged', {
  desc = 'Auto-read exrc',
  callback = function() end,
})
-- autocmds.create('SwapExists', {
--   desc = 'Handle some swap file handling automatically',
--   callback = function(args)
--     local file = args.file
--     local swap = vim.v.swapname
--     if vim.fn.getftime(swap) < vim.fn.getftime(file) then
--       vim.v.swapchoice = 'd'
--       print('Deleted old swapfile')
--     end
--   end
-- })

local heirline_colors = {}
-- called in heirline setup
function autocmds.heirline_mode_cursorline(mode_colors)
  local function update_heirline_colors()
    heirline_colors = {
      mode = mode_colors,
      loaded = require('heirline.highlights').get_loaded_colors(),
      cached_hexes = {},
    }
  end
  update_heirline_colors()
  autocmds.create('ColorScheme', {
    callback = update_heirline_colors,
    desc = 'Make sure that the heirline colors are updated when colorscheme changes',
  })
  local cursorline_bg_hex = utils.nvim_get_hl_hex(0, { name = 'CursorLine' }).bg
  vim.api.nvim_set_hl(0, 'ModeCursorLine', { bg = cursorline_bg_hex })

  autocmds.create({ 'VimEnter', 'ModeChanged' }, {
    callback = function()
      local mode = vim.fn.mode()
      local hex = heirline_colors.cached_hexes[mode]
      if not hex then
        local mode_color = heirline_colors.loaded[heirline_colors.mode[mode]]
        if not mode_color then
          hex = cursorline_bg_hex
        else
          hex = ('%06x'):format(mode_color)
          hex = table.concat(
            vim.tbl_map(
              function(i) return ('%02x'):format(math.floor(tonumber('0x' .. hex:sub(unpack(i))) / 4.5)) end,
              { { 1, 2 }, { 3, 4 }, { 5, 6 } }
            ),
            ''
          )
        end
        heirline_colors.cached_hexes[mode] = hex
      end
      vim.cmd.highlight('ModeCursorLine guibg=#' .. hex)
      vim.opt_local.winhighlight:append('CursorLine:ModeCursorLine')
      vim.cmd.redraw()
    end,
    desc = 'Change mode cursorline',
  })
  autocmds.create({ 'BufWinEnter', 'WinEnter', 'CmdLineLeave' }, {
    callback = function() vim.opt_local.winhighlight:append('CursorLine:ModeCursorLine') end,
    desc = 'Enable mode cursorline for current windows',
  })
  autocmds.create({ 'WinLeave', 'CmdLineEnter' }, {
    callback = function() vim.opt_local.winhighlight:remove({ 'CursorLine' }) end,
    desc = 'Disable mode cursorline for non-current windows',
  })
end

-- called after setting up tint plugins
function autocmds.setup_overrides()
  autocmds.create({ 'ColorScheme' }, {
    callback = function(details)
      if vim.g.disable_pynappo_theme_overrides then return end
      require('pynappo.theme').overrides.all:apply()
      require('pynappo.theme').overrides[details.match]:apply()
    end,
  })
end

local skeletons = {}

local skeletons_loaded = false
autocmds.create({ 'BufNewFile', 'BufNew' }, {
  once = true,
  desc = 'Lazy-loaded skeletons',
  callback = function(ctx)
    if skeletons_loaded then return end
    skeletons_loaded = true
    for _, dir in pairs(vim.api.nvim_get_runtime_file('skeleton/*', true)) do
      local ft = vim.fn.fnamemodify(dir, ':t')
      for _, skeleton in pairs(vim.api.nvim_get_runtime_file('skeleton/' .. ft .. '/*', true)) do
        if not skeletons[ft] then
          skeletons[ft] = { skeleton }
        else
          table.insert(skeletons[ft], skeleton)
        end
      end
    end

    local scratch = 'Start from scratch'
    vim.api.nvim_create_user_command('Skeleton', function(ctx)
      local ft = vim.bo[0].filetype
      if skeletons[ft] then
        vim.ui.select({ scratch, unpack(skeletons[ft]) }, {
          prompt = 'Select skeleton',
        }, function(choice)
          if not choice then
            vim.notify('No skeleton selected', vim.log.levels.INFO)
            return
          end
          if choice == scratch then return end
          vim.cmd('0r ' .. choice)
        end)
      else
        vim.notify('no skeleton found for ' .. ft .. ', skeletons:' .. vim.inspect(skeletons), vim.log.levels.INFO)
      end
    end, {})
  end,
})

local iterations = 1
local BUFSIZE = 2 ^ 13 -- 4KB
autocmds.create({ 'BufNewFile', 'BufNew' }, {
  callback = function(ctx)
    if vim.b[ctx.buf].skeleton_prompted then return end
    vim.b[ctx.buf].skeleton_prompted = true
    if vim.bo[ctx.buf].buftype ~= '' then return end
    -- read 1 bufsize worth, return early if we have too many lines
    local f = io.open(ctx.file, 'r')
    if not f then return end
    local t = 0
    local lc = 0
    for i = 0, iterations do
      local lines, rest = f:read(BUFSIZE, '*line')
      if not lines then return end
      if rest then lines = lines .. rest .. '\n' end
      _, t = string.gsub(lines, '\n', '\n')
      lc = lc + t
      if lc > 3 then return end
    end
    vim.schedule(vim.cmd.Skeleton)
    -- if vim.api.nvim_buf_line_count(ctx.buf) < 2 and not vim.b[ctx.buf].skeleton_prompted then
    --   vim.b[ctx.buf].skeleton_prompted = true
    --   vim.schedule(vim.cmd.Skeleton)
    -- end
  end,
})

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  callback = function(details)
    local client = vim.lsp.get_client_by_id(details.data.client_id) or {}
    if not client then return end
    local keymaps = require('pynappo.keymaps')
    local bufnr = details.buf
    if vim.tbl_contains({ 'copilot', 'null-ls' }, client.name or vim.print('no client found')) then return end

    -- if client.server_capabilities.colorProvider then
    --   vim.lsp.document_color.enable(true, bufnr, { style = 'background' })
    -- end
    if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        callback = function() vim.lsp.codelens.refresh({ bufnr = 0 }) end,
        buffer = bufnr,
      })
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'codelens', buffer = bufnr })
    end
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.api.nvim_create_autocmd('LspNotify', {
      callback = function(args)
        if args.data.method == 'textDocument/didOpen' then vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf)) end
      end,
    })
    keymaps.setup.lsp(bufnr)
    vim.b[bufnr].lsp_attached = true
  end,
})

return autocmds

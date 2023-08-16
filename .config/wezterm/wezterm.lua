local wezterm = require('wezterm')
local config = wezterm.config_builder()
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local launch_menu = {}
if is_windows then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe' },
  })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in
    ipairs(
      wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)')
    )
    do
    local year = vsvers:gsub('Microsoft Visual Studio/', '')
    table.insert(launch_menu, {
      label = 'x64 Native Tools VS ' .. year,
      args = {
        'cmd.exe',
        '/k',
        'C:/Program Files (x86)/'
          .. vsvers
          .. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
      },
    })
  end

  local success, wsl_list, wsl_err = wezterm.run_child_process { 'wsl.exe', '-l' }
  if success then
    wsl_list = wezterm.utf16_to_utf8(wsl_list)
    for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
      if idx > 1 then
        local distro = line:gsub(' %(Default%)', '')
        table.insert(launch_menu, {
          label = distro .. ' (WSL default shell)',
          args = { 'wsl.exe', '--distribution', distro },
        })
      end
    end
  end
end
config.launch_menu = launch_menu
config.debug_key_events = true
config.max_fps = 144
config.color_scheme = 'Ayu Mirage'
config.font = wezterm.font_with_fallback({
  'Inconsolata Nerd Font Mono',
  { family = "Symbols NFM", scale = 0.5 },
  'Noto Color Emoji',
})
config.default_prog = { is_windows and 'pwsh' or 'fish' }

config.window_background_opacity = 0.9
config.text_background_opacity = 0.9

config.scrollback_lines = 3500
config.enable_scroll_bar = true
config.default_cursor_style = 'BlinkingBar'

-- freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'

config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = 'https://www.github.com/$1/$3',
})
config.enable_kitty_keyboard = true

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

config.keys = {
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
}

return config

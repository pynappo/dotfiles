local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder()
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local launch_menu = {}
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
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

  -- Enumerate any WSL distributions that are installed and add those to the menu
  local success, wsl_list, wsl_err = wezterm.run_child_process { 'wsl.exe', '-l' }
  if success then
    -- `wsl.exe -l` has a bug where it always outputs utf16:
    -- https://github.com/microsoft/WSL/issues/4607
    -- So we get to convert it
    wsl_list = wezterm.utf16_to_utf8(wsl_list)

    for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
      -- Skip the first line of output; it's just a header
      if idx > 1 then
        -- Remove the "(Default)" marker from the default line to arrive
        -- at the distribution name on its own
        local distro = line:gsub(' %(Default%)', '')

        -- Add an entry that will spawn into the distro with the default shell
        table.insert(launch_menu, {
          label = distro .. ' (WSL default shell)',
          args = { 'wsl.exe', '--distribution', distro },
        })

        -- Here's how to jump directly into some other program; in this example
        -- its a shell that probably isn't the default, but it could also be
        -- any other program that you want to run in that environment
        table.insert(launch_menu, {
          label = distro .. ' (WSL zsh login shell)',
          args = {
            'wsl.exe',
            '--distribution',
            distro,
            '--exec',
            '/bin/zsh',
            '-l',
          },
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
  { family = "Symbols NFM", scale = 0.4 },
  'Noto Color Emoji',
})
config.default_prog = { is_windows and 'pwsh' or 'fish' }

return {
  debug_key_events = true,
  max_fps = 144,
  color_scheme = 'Ayu Mirage',
  font = wezterm.font_with_fallback({
    'Inconsolata Nerd Font Mono',
    { family = "Symbols NFM", scale = 0.5 },
    'Noto Color Emoji',
  }),
  default_prog = { is_windows and 'pwsh' or 'fish' },

  window_background_opacity = 0.9,
  text_background_opacity = 0.9,

  scrollback_lines = 3500,
  enable_scroll_bar = true,
  default_cursor_style = 'BlinkingBar',

  -- freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',

  tab_bar_at_bottom = false,
  use_fancy_tab_bar = true,
  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    { regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b', format = '$0', },

    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    { regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = 'mailto:$0', },
    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    { regex = [[\bfile://\S*\b]], format = '$0', },
    -- Make task numbers clickable
    -- The first matched regex group is captured in $1.
    { regex = [[\b[tT](\d+)\b]], format = 'https://example.com/tasks/?t=$1', },

    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    { regex = [[["]{1}([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]{1}]], format = 'https://www.github.com/$1/$3', },
  },
  enable_kitty_keyboard = true,
}


config.disable_default_key_bindings = true
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
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
  { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
  { key = '!', mods = 'CTRL', action = act.ActivateTab(0) },
  { key = '!', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
  { key = '\"', mods = 'ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  { key = '\"', mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  { key = '#', mods = 'CTRL', action = act.ActivateTab(2) },
  { key = '#', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
  { key = '$', mods = 'CTRL', action = act.ActivateTab(3) },
  { key = '$', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
  { key = '%', mods = 'CTRL', action = act.ActivateTab(4) },
  { key = '%', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
  { key = '%', mods = 'ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  { key = '%', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  { key = '&', mods = 'CTRL', action = act.ActivateTab(6) },
  { key = '&', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
  { key = '\'', mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  { key = '(', mods = 'CTRL', action = act.ActivateTab(-1) },
  { key = '(', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
  { key = ')', mods = 'CTRL', action = act.ResetFontSize },
  { key = ')', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
  { key = '*', mods = 'CTRL', action = act.ActivateTab(7) },
  { key = '*', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '-', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
  { key = '0', mods = 'SUPER', action = act.ResetFontSize },
  { key = '1', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
  { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
  { key = '2', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
  { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
  { key = '3', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
  { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
  { key = '4', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
  { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
  { key = '5', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
  { key = '5', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
  { key = '6', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
  { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
  { key = '7', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
  { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
  { key = '8', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
  { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },
  { key = '9', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
  { key = '9', mods = 'SUPER', action = act.ActivateTab(-1) },
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '=', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
  { key = '@', mods = 'CTRL', action = act.ActivateTab(1) },
  { key = '@', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
  { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'K', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  { key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
  { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  { key = 'M', mods = 'CTRL', action = act.Hide },
  { key = 'M', mods = 'SHIFT|CTRL', action = act.Hide },
  { key = 'N', mods = 'CTRL', action = act.SpawnWindow },
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  { key = 'P', mods = 'CTRL', action = act.ActivateCommandPalette },
  { key = 'P', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  { key = 'R', mods = 'CTRL', action = act.ReloadConfiguration },
  { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  { key = 'T', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'T', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'U', mods = 'CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  { key = 'U', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'W', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'X', mods = 'CTRL', action = act.ActivateCopyMode },
  { key = 'X', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
  { key = 'Z', mods = 'CTRL', action = act.TogglePaneZoomState },
  { key = 'Z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  { key = '[', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
  { key = '^', mods = 'CTRL', action = act.ActivateTab(5) },
  { key = '^', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
  { key = '_', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
  { key = 'f', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  { key = 'm', mods = 'SHIFT|CTRL', action = act.Hide },
  { key = 'm', mods = 'SUPER', action = act.Hide },
  { key = 'n', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
  { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  { key = 'r', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
  { key = 't', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'u', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
  { key = 'w', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'x', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
  { key = 'z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  { key = '{', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
  { key = '{', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
  { key = '}', mods = 'SUPER', action = act.ActivateTabRelative(1) },
  { key = '}', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
  { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
  { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
  { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
  { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
  { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
  { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
  { key = 'LeftArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
  { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
  { key = 'RightArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
  { key = 'UpArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },
  { key = 'DownArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
  { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
  { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
  { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
  { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },

}

config.key_tables = {
  copy_mode = {
    { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
    { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
    { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
    { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
    { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
    { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
    { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
    { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
    { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
    { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
    { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
    { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
    { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
    { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
    { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
    { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
    { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
    { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
    { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
    { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
    { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
    { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
    { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
    { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
    { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
    { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
    { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
    { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
    { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
    { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
    { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
    { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
    { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
    { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
  },
  search_mode = {
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
    { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
    { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
    { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
  }
}

return config

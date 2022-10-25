local wezterm = require('wezterm')
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
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
  local success, wsl_list, wsl_err =
  wezterm.run_child_process { 'wsl.exe', '-l' }
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

local config = {
  max_fps = 165,
  color_scheme = 'Ayu Mirage',
  font = wezterm.font('Inconsolata NFM'),
  default_prog = { 'pwsh' },

  window_background_opacity = 0.9,
  text_background_opacity = 0.9,

  scrollback_lines = 3500,
  enable_scroll_bar = true,

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
    { regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]], format = 'https://www.github.com/$1/$3', },
  },
  enable_kitty_keyboard = true,
}

return config

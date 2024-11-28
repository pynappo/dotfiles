local should_profile = os.getenv('NVIM_PROFILE')
return {
  'stevearc/profile.nvim',
  enabled = should_profile,
  config = function()
    require('profile').instrument_autocmds()
    if should_profile and should_profile:lower():match('^start') then
      require('profile').start('*')
    else
      require('profile').instrument('*')
    end

    local function toggle_profile()
      local prof = require('profile')
      if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = 'Save profile to:', completion = 'file', default = 'profile.json' }, function(filename)
          if filename then
            prof.export(filename)
            vim.notify(string.format('Wrote %s', filename))
          end
        end)
      else
        prof.start('*')
      end
    end
    vim.keymap.set('', '<f1>', toggle_profile)
  end,
}

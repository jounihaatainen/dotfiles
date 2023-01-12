local M = {}

function M.setup(settings)
  local m = hs.hotkey.modal.new(settings.enter.modifiers, settings.enter.key, nil)
  local logger = hs.logger.new('window-layout', 'debug')

  hs.fnutils.each(settings.layouts, function(entry)
    m:bind('', entry.key, function()
      if hs.window.focusedWindow() == nil then
        logger.e("Please, turn on the Accessibility for Hammerspoon in System Settings > Privacy & Security > Accessibility")
      end
      hs.window.focusedWindow():moveToUnit(entry.unit)
      m:exit()
    end)
    m:bind(settings.moveToScreenModifier, entry.key, function()
      hs.window.focusedWindow():moveToUnit(entry.unit)
        :moveToScreen(hs.window.focusedWindow():screen():next())
      m:exit()
    end)
  end)

  hs.fnutils.each(settings.escape, function(entry)
    m:bind(entry.modifiers, entry.key, nil, function() m:exit() end)
  end)
end

return M

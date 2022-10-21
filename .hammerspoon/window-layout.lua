local M = {}

function M.setup(settings)
  local m = hs.hotkey.modal.new(settings.enter.modifiers, settings.enter.key, nil)

  hs.fnutils.each(settings.layouts, function(entry)
    m:bind('', entry.key, nil, function()
      hs.window.focusedWindow():moveToUnit(entry.unit)
      m:exit()
    end)
    m:bind(settings.moveToScreenModifier, entry.key, nil, function()
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

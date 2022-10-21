local M = {}

function M.setup(settings)
  hs.fnutils.each(settings, function(entry)
    hs.hotkey.bind(entry.mods, entry.key, function()
      local app = hs.application.get(entry.appName)
      if app and app:isFrontmost() then
        app:hide()
        return
      end
      hs.application.launchOrFocus(entry.appName)
    end)
  end)
end

return M

local M = {}

-- Switch to application's next window
function M.nextWindowForApp(app)
  local windows = hs.window.orderedWindows()
  local appWindows = hs.fnutils.ifilter(windows, function(win)
    return win:application() == app
  end)

  if appWindows and #appWindows > 1 then
    appWindows[#appWindows]:focus()
  end
end

function M.nextWindowForCurrentApp()
  local window = hs.window.focusedWindow()
  local app = window:application()
  M.nextWindowForApp(app)
end

return M

local M = {}

M._watcher = nil

-- Bring all Finder windows to front when Finder is activated
local function appWatcherFn(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
    end
end

function M.start()
  if M._watcher then
    M.stop()
  end

  M._watcher = hs.application.watcher.new(appWatcherFn)
  M._watcher:start()
end

function M.stop()
  if M._watcher then
    M._watcher:stop()
    M._watcher = nil
  end
end

return M

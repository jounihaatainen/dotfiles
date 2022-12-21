local M = {}

-- TODO: Figure out how to do this
local layouts = {
  {--   appName = "WezTerm",
    windowTitle = nil,
    screenConfigs = {
      { screenName = "HP ZR2740w", unitRect = hs.layout.maximized, frameRect = nil, fullFrameRect = nil },
      { screenName = "Built-in Retina Display", unitRect = hs.layout.maximized, frameRect = nil, fullFrameRect = nil },
      { screenName = nil, unitRect = hs.layout.maximized, frameRect = nil, fullFrameRect = nil }
    }
  },
  {
    appName = "Slack",
    windowTitle = nil,
    screenConfigs = {
      { screenName = "HP ZR2740w", unitRect = hs.geometry(0.15, 0.1, 0.7, 0.8), frameRect = nil, fullFrameRect = nil },
      { screenName = "Built-in Retina Display", unitRect = hs.layout.maximized, frameRect = nil, fullFrameRect = nil },
      { screenName = nil, unitRect = hs.geometry(0.15, 0.1, 0.7, 0.8), frameRect = nil, fullFrameRect = nil }
    }
  }
}

M._layouts = {}
M._watcher = nil

function M.setup(layouts)
  M._layouts = layouts
end

function M.start()
  M.stop()
  M._watcher = hs.screen.watcher.new(function()
    M._screenConfigurationChangedFn()
  end)
  M._watcher:start()
  M._screenConfigurationChangedFn()
end

function M.stop()
  if M._watcher then
    M._watcher:stop()
    M._watcher = nil
  end
end

function M._screenConfigurationChangedFn()
  local screens = hs.screen.allScreens()

  for i, screen in ipairs(screens) do
    print("screen " .. i .. ": " .. screen:name())
    -- local layout1 = {
    --   {"Mail", nil, "Color LCD", hs.layout.maximized, nil, nil},
    --   {"Safari", nil, "Thunderbolt Display", hs.layout.maximized, nil, nil},
    --   {"iTunes", "iTunes", "Color LCD", hs.layout.maximized, nil, nil},
    --   {"iTunes", "MiniPlayer", "Color LCD", nil, nil, hs.geometry.rect(0, -48, 400, 48)},
    -- }
    -- hs.layout.apply(layout)
  end
end

return M

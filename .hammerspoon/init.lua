-- Load & start Spoons
local holdToQuit = hs.loadSpoon("HoldToQuit")
holdToQuit.duration = 1.5
holdToQuit:start()

-- Keybindings
local bind = hs.hotkey.bind
local hyper = { "cmd", "alt", "ctrl", "shift" }
local meh = { "cmd", "alt", "ctrl" }

local appShortcuts = {
  { mods=hyper, key='f', app="Finder" },
  { mods=hyper, key='w', app="Safari" },
  { mods=hyper, key='c', app="Google Chrome" },
  { mods=hyper, key='t', app="WezTerm" },
  { mods=hyper, key='o', app="Microsoft Outlook" },
  { mods=hyper, key='s', app="Slack" },
  { mods=hyper, key='e', app="Microsoft Excel" },
  { mods=hyper, key='i', app="Inkscape" },
  { mods=hyper, key='g', app="GitHub Desktop" },
  { mods=hyper, key='m', app="Spotify" },
  { mods=hyper, key='p', app="Preview" },
  { mods=hyper, key='v', app="Vial" },
  { mods=hyper, key='d', app="Docker Desktop" },
  { mods=hyper, key='a', app="Azure Data Studio" }
}

hs.fnutils.each(appShortcuts, function(entry)
  bind(entry.mods, entry.key, function()
    local app = hs.application.get(entry.app)
    if app then
      if app:isFrontmost() then
        app:hide()
      else
        app:mainWindow():focus()
      end
    else
      hs.application.launchOrFocus(entry.app)
    end
  end)
end)

local grid = {
  { key='j', unit=hs.geometry.rect(0, 0.5, 1, 0.5) },
  { key='k', unit=hs.geometry.rect(0, 0, 1, 0.5) },
  { key='h', unit=hs.layout.left50 },
  { key='l', unit=hs.layout.right50 },
  { key='y', unit=hs.geometry.rect(0, 0, 0.5, 0.5) },
  { key='u', unit=hs.geometry.rect(0.5, 0, 0.5, 0.5) },
  { key='b', unit=hs.geometry.rect(0, 0.5, 0.5, 0.5) },
  { key='n', unit=hs.geometry.rect(0.5, 0.5, 0.5, 0.5) },
  { key='r', unit=hs.layout.left70 },
  { key='t', unit=hs.layout.right30 },
  { key='return', unit=hs.layout.maximized },
  { key='space', unit=hs.geometry(0.15, 0.1, 0.7, 0.8) },
}

local m = hs.hotkey.modal.new(hyper, 'u')

hs.fnutils.each(grid, function(entry)
  m:bind('', entry.key, function()
    hs.window.focusedWindow():moveToUnit(entry.unit)
    m:exit()
  end)
  m:bind('shift', entry.key, function()
    hs.window.focusedWindow():moveToUnit(entry.unit)
      :moveToScreen(hs.window.focusedWindow():screen():next())
    m:exit()
  end)
  m:bind('', 'escape', function() m:exit() end)
  m:bind('ctrl', 'c', function() m:exit() end)
end)


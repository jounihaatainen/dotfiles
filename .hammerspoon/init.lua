local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Load & start Spoons
hs.loadSpoon("HoldToQuit")
spoon.HoldToQuit:start()

-- App activation
local function openApp(name)
  local app = hs.application.get(name)
  if app then
    if app:isFrontmost() then
      app:hide()
    else
      app:mainWindow():focus()
    end
  else
    hs.application.launchOrFocus(name)
  end
end

local function activateAppFunc(name)
  return function ()
    openApp(name)
  end
end

hs.hotkey.bind(hyper, 'f', activateAppFunc("Finder"))
hs.hotkey.bind(hyper, 'w', activateAppFunc("Safari"))
hs.hotkey.bind(hyper, 'c', activateAppFunc("Google Chrome"))
hs.hotkey.bind(hyper, 't', activateAppFunc("WezTerm"))
hs.hotkey.bind(hyper, 'o', activateAppFunc("Microsoft Outlook"))
hs.hotkey.bind(hyper, 's', activateAppFunc("Slack"))
hs.hotkey.bind(hyper, 'e', activateAppFunc("Microsoft Excel"))
hs.hotkey.bind(hyper, 'i', activateAppFunc("Inkscape"))
hs.hotkey.bind(hyper, 'g', activateAppFunc("GitHub Desktop"))
hs.hotkey.bind(hyper, 'm', activateAppFunc("Spotify"))
hs.hotkey.bind(hyper, 'p', activateAppFunc("Preview"))

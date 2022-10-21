-- Load & start Spoons
local holdToQuit = hs.loadSpoon("HoldToQuit")
holdToQuit.duration = 1.5
holdToQuit:start()

-- Bring all Finder windows to front when Finder is activated
local finderWatcher = require("finder-watcher")
finderWatcher.start()

-- Keybinding helpers
local hyper = { "cmd", "alt", "ctrl", "shift" }
local meh = { "cmd", "alt", "ctrl" }

-- Switch to application's next window
local windowSwitch = require("window-switch")

hs.hotkey.bind(hyper, 'n', function()
  windowSwitch.nextWindowForCurrentApp()
end)

-- Keybindings for fast application switching
local appShortcuts = {
  { mods=hyper, key='f', appName="Finder" },
  { mods=hyper, key='w', appName="Safari" },
  { mods=hyper, key='c', appName="Google Chrome" },
  { mods=hyper, key='t', appName="WezTerm" },
  { mods=hyper, key='o', appName="Microsoft Outlook" },
  { mods=hyper, key='s', appName="Slack" },
  { mods=hyper, key='e', appName="Microsoft Excel" },
  { mods=hyper, key='i', appName="Inkscape" },
  { mods=hyper, key='g', appName="GitHub Desktop" },
  { mods=hyper, key='m', appName="Spotify" },
  { mods=hyper, key='p', appName="Preview" },
  { mods=hyper, key='v', appName="Vial" },
  { mods=hyper, key='d', appName="Docker Desktop" },
  { mods=hyper, key='a', appName="Azure Data Studio" },
  { mods=hyper, key='x', appName="Xcode" },
  { mods=hyper, key='q', appName="qutebrowser" },
}

local appSwitch = require("app-switch")
appSwitch.setup(appShortcuts)

-- Keybindings for window layout management
local layouts = {
  { key='j', unit=hs.geometry.rect(0, 0.5, 1, 0.5) },
  { key='k', unit=hs.geometry.rect(0, 0, 1, 0.5) },
  { key='h', unit=hs.layout.left50 },
  { key='l', unit=hs.layout.right50 },
  { key='down', unit=hs.geometry.rect(0, 0.5, 1, 0.5) },
  { key='up', unit=hs.geometry.rect(0, 0, 1, 0.5) },
  { key='left', unit=hs.layout.left50 },
  { key='right', unit=hs.layout.right50 },
  { key='y', unit=hs.geometry.rect(0, 0, 0.5, 0.5) },
  { key='u', unit=hs.geometry.rect(0.5, 0, 0.5, 0.5) },
  { key='n', unit=hs.geometry.rect(0, 0.5, 0.5, 0.5) },
  { key='m', unit=hs.geometry.rect(0.5, 0.5, 0.5, 0.5) },
  { key='r', unit=hs.layout.left70 },
  { key='t', unit=hs.layout.right30 },
  { key='return', unit=hs.layout.maximized },
  { key='space', unit=hs.geometry(0.15, 0.1, 0.7, 0.8) },
}

local winLayout = require("window-layout")
winLayout.setup {
  enter = { modifiers = hyper, key = 'u', },
  escape = {
    { modifiers = '', key = 'escape', },
    { modifiers = 'ctrl', key = 'c', }
  },
  moveToScreenModifier = 'shift',
  layouts = layouts,
}

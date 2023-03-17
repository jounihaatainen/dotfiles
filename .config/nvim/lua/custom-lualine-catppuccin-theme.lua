local C = require("catppuccin.palettes").get_palette()
local O = require("catppuccin").options
local catppuccin = {}

local transparent_bg = O.transparent_background and "NONE" or C.mantle

catppuccin.normal = {
	a = { bg = C.blue, fg = C.mantle, gui = "bold" },
	b = { bg = C.surface1, fg = C.blue },
	c = { bg = transparent_bg, fg = C.text },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

catppuccin.insert = {
	a = { bg = C.green, fg = C.base, gui = "bold" },
	b = { bg = C.surface1, fg = C.teal },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

catppuccin.terminal = {
	a = { bg = C.green, fg = C.base, gui = "bold" },
	b = { bg = C.surface1, fg = C.teal },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

catppuccin.command = {
	a = { bg = C.peach, fg = C.base, gui = "bold" },
	b = { bg = C.surface1, fg = C.peach },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

catppuccin.visual = {
	a = { bg = C.mauve, fg = C.base, gui = "bold" },
	b = { bg = C.surface1, fg = C.mauve },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

catppuccin.replace = {
	a = { bg = C.red, fg = C.base, gui = "bold" },
	b = { bg = C.surface1, fg = C.red },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

catppuccin.inactive = {
	a = { bg = transparent_bg, fg = C.blue },
	b = { bg = transparent_bg, fg = C.surface1, gui = "bold" },
	c = { bg = transparent_bg, fg = C.overlay0 },
  y = { bg = C.maroon, fg = C.mantle },
  z = { bg = C.flamingo, fg = C.mantle }
}

return catppuccin

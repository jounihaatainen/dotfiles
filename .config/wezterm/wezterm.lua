local wezterm = require "wezterm"

function scheme_for_appearance(appearance)
	if appearance:find "Dark" then
		return "Catppuccin Frappe"
	else
		return "Catppuccin Latte"
	end
end

return {
  send_composed_key_when_left_alt_is_pressed = true,
  font_size = 18.0,
  -- color_scheme = "JetBrains Darcula",
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
  native_macos_fullscreen_mode = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }
}

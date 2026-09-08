-- WezTerm configuration
-- (repo copy lives in the dotfiles at wezterm/wezterm.lua)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font: WezTerm bundles JetBrains Mono, so no extra install is needed.
config.font = wezterm.font("JetBrains Mono")
config.font_size = 11.0

-- Default shell: on Windows launch PowerShell 7 (pwsh) so the oh-my-posh
-- gruvbox prompt and the PSReadLine/PSFzf profile load, instead of the default
-- cmd.exe. On Linux/macOS WezTerm uses the default login shell.
if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Colors: gruvbox dark, soft.
config.color_scheme = "Gruvbox dark, soft (base16)"

-- Zero the window padding so nvim fills the window edge-to-edge. With padding,
-- the padding strip is painted with WezTerm's background while nvim paints its
-- own, and the slightly different shades look like a thin frame around nvim.
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Start maximized: fills the screen but keeps the window border/title bar
-- (as opposed to native borderless fullscreen).
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config

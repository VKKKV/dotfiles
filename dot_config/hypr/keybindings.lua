local shared = require("shared")

local moveactivewindow_cmd = [[test "$(hyprctl activewindow -j | jq -r .floating)" = "true" && hyprctl dispatch moveactive]]

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + Return", hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))

hl.bind("SUPER + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive b"))
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))

hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext"))

hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 200 0"), { repeating = true })
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -200 0"), { repeating = true })
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -200"), { repeating = true })
hl.bind("SUPER + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 200"), { repeating = true })

hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.exec_cmd(moveactivewindow_cmd .. " -30 0 || hyprctl dispatch movewindow l"), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.exec_cmd(moveactivewindow_cmd .. " 30 0 || hyprctl dispatch movewindow r"), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + K", hl.dsp.exec_cmd(moveactivewindow_cmd .. " 0 -30 || hyprctl dispatch movewindow u"), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + J", hl.dsp.exec_cmd(moveactivewindow_cmd .. " 0 30 || hyprctl dispatch movewindow d"), { repeating = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + X", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))

hl.bind("SUPER + T", hl.dsp.exec_cmd(shared.terminal))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("[float; move 25% 25%; size 60% 60%] " .. shared.terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(shared.explorer))
hl.bind("SUPER + F", hl.dsp.exec_cmd(shared.browser))

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"), { locked = true, repeating = true })

for i = 1, 10 do
  local key = tostring(i % 10)
  local workspace = tostring(i)

  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
  hl.bind("SUPER + CTRL + " .. key, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. workspace))
end

hl.bind("SUPER + ALT + L", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + ALT + H", hl.dsp.focus({ workspace = "r-1" }))

hl.bind("SUPER + CTRL + Down", hl.dsp.exec_cmd("hyprctl dispatch workspace empty"))
hl.bind("SUPER + CTRL + ALT + L", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace r+1"))
hl.bind("SUPER + CTRL + ALT + H", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace r-1"))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
hl.bind("SUPER + CTRL + S", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent special"))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special(""))

local shared = require("shared")
local src_path = shared.src_path

hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("thunar --daemon")
  hl.exec_cmd("[workspace 2 silent] ghostty")
  hl.exec_cmd("[workspace 1 silent] zen-browser")
end)

hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd("pkill -x waybar || waybar &"))
hl.bind("SUPER + space", hl.dsp.exec_cmd("pkill -x rofi || rofi -show drun -replace -i -config ~/.config/rofi/config.rasi"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill -x rofi || " .. src_path .. "/cliphist.sh -c"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd("pkill -x rofi || " .. src_path .. "/emoji-picker.sh"))
hl.bind("SUPER + period", hl.dsp.exec_cmd("pkill -x rofi || " .. src_path .. "/glyph-picker.sh"))
hl.bind("SUPER + ALT + G", hl.dsp.exec_cmd(src_path .. "/gamemode.sh"))
hl.bind("SUPER + ALT + Q", hl.dsp.dpms({ action = "toggle" }))
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("systemctl suspend"))

hl.bind(
  "SUPER + I",
  hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")]])
)
hl.bind(
  "SUPER + O",
  hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")]])
)

hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -an"))
hl.bind("SUPER + CTRL + P", hl.dsp.exec_cmd(src_path .. "/screenshot.sh sf"))
hl.bind("SUPER + CTRL + SHIFT + P", hl.dsp.exec_cmd(src_path .. "/screenshot.sh sq"))
hl.bind("SUPER + CTRL + SHIFT + ALT + P", hl.dsp.exec_cmd(src_path .. "/screenshot.sh m"))
hl.bind("SUPER + P", hl.dsp.exec_cmd(src_path .. "/screenshot.sh s"))
hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd(src_path .. "/screenshot.sh sc"), { locked = true })
hl.bind("Print", hl.dsp.exec_cmd(src_path .. "/screenshot.sh p"), { locked = true })

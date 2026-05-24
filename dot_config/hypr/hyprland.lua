require("shared")
require("base")
require("monitors")
require("windowrules")
require("keybindings")
require("desktop")

local easymotion = require("easymotion")

hl.bind("SUPER + R", function()
  local ok, err = easymotion.activate()
  if not ok then
    print("easymotion: " .. tostring(err))
  end
end)

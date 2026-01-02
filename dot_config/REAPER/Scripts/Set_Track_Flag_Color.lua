local colors = {
  {91, 206, 250},
  {245, 169, 184},
  {255, 255, 255} 
}

local count = reaper.CountSelectedTracks(0)
if count > 0 then
  for i = 0, count - 1 do
    local track = reaper.GetSelectedTrack(0, i)

    local color_choice = colors[math.random(#colors)]
    local r, g, b = color_choice[1], color_choice[2], color_choice[3]

    reaper.SetTrackColor(track, reaper.ColorToNative(r, g, b))
  end
end


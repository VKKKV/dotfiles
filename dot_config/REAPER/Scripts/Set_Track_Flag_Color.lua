local flag_colors = {
  {91, 207, 250},
  {245, 171, 185},
  {255, 255, 255},
  {245, 171, 185}
}

function loop_colors()
  local count = reaper.CountSelectedTracks(0)
  if count == 0 then return end

  for i = 0, count - 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local track_idx = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")

    track_idx = math.floor(track_idx)

    local color_index = ((track_idx - 1) % #flag_colors) + 1
    local selected_color = flag_colors[color_index]

    local r, g, b = selected_color[1], selected_color[2], selected_color[3]

    local native_color = reaper.ColorToNative(r, g, b) | 0x1000000
    reaper.SetTrackColor(track, native_color)
  end
end

reaper.Undo_BeginBlock()
loop_colors()
reaper.Undo_EndBlock("Set Track Flag Color Loop", -1)

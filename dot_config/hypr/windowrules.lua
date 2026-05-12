local function add_rules(rules)
  for _, rule in ipairs(rules) do
    hl.window_rule(rule)
  end
end

local function add_layer_rules(rules)
  for _, rule in ipairs(rules) do
    hl.layer_rule(rule)
  end
end

add_rules({
  { match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" }, idle_inhibit = "fullscreen" },
  { match = { class = "^(.*[Ss]potify.*)$" }, idle_inhibit = "fullscreen" },
  { match = { class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$" }, idle_inhibit = "fullscreen" },

  { match = { class = "^(firefox)$" }, opacity = "0.90 0.90 1" },
  { match = { class = "^(brave-browser)$" }, opacity = "0.90 0.90 1" },
  { match = { class = "^(code-oss)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^([Cc]ode)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(code-url-handler)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(code-insiders-url-handler)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(kitty)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(org.kde.dolphin)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(org.kde.ark)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(nwg-look)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(qt5ct)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(qt6ct)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(kvantummanager)$" }, opacity = "0.80 0.80 1" },
  { match = { class = "^(org.pulseaudio.pavucontrol)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(blueman-manager)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(nm-applet)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(nm-connection-editor)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(polkit-gnome-authentication-agent-1)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$" }, opacity = "0.80 0.70 1" },
  { match = { class = "^([Ss]team)$" }, opacity = "0.70 0.70 1" },
  { match = { class = "^(steamwebhelper)$" }, opacity = "0.70 0.70 1" },
  { match = { class = "^([Ss]potify)$" }, opacity = "0.70 0.70 1" },
  { match = { initial_title = "^(Spotify Free)$" }, opacity = "0.70 0.70 1" },
  { match = { initial_title = "^(Spotify Premium)$" }, opacity = "0.70 0.70 1" },

  { match = { class = "^(com.github.rafostar.Clapper)$" }, opacity = "0.90 0.90" },
  { match = { class = "^(com.github.tchx84.Flatseal)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(hu.kramo.Cartridges)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(com.obsproject.Studio)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(gnome-boxes)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(vesktop)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(discord)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(WebCord)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(ArmCord)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(app.drey.Warp)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(net.davidotek.pupgui2)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(yad)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(Signal)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(io.github.alainm23.planify)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(com.github.unrud.VideoDownloader)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(io.gitlab.adhami3310.Impression)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(io.missioncenter.MissionCenter)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(io.github.flattool.Warehouse)$" }, opacity = "0.80 0.80" },
  { match = { class = "^(com.mitchellh.ghostty)$" }, opacity = "0.90 0.90" },

  { match = { class = "^(Signal)$" }, float = true },
  { match = { class = "^(com.github.rafostar.Clapper)$" }, float = true },
  { match = { class = "^(app.drey.Warp)$" }, float = true },
  { match = { class = "^(net.davidotek.pupgui2)$" }, float = true },
  { match = { class = "^(yad)$" }, float = true },
  { match = { class = "^(eog)$" }, float = true },
  { match = { class = "^(io.github.alainm23.planify)$" }, float = true },
  { match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" }, float = true },
  { match = { class = "^(com.github.unrud.VideoDownloader)$" }, float = true },
  { match = { class = "^(io.gitlab.adhami3310.Impression)$" }, float = true },
  { match = { class = "^(io.missioncenter.MissionCenter)$" }, float = true },

  { match = { class = "^jetbrains-.+$", title = "^win[0-9]+$" }, no_initial_focus = true },
  { match = { class = "^(com.follow.clash)$" }, no_initial_focus = true },
  { match = { class = "^(REAPER)$" }, no_initial_focus = true },
  { match = { class = "^$" }, no_focus = true },
  { match = { title = "^(menu)$", class = "^$" }, stay_focused = true },
  { match = { class = "^(OpenUtau)$" }, float = true },
  { match = { class = "^(steam_proton)$" }, float = true },
  { match = { class = "^(com.hex-rays.ida)$" }, float = true },
})

add_layer_rules({
  { match = { namespace = "rofi" }, blur = true },
  { match = { namespace = "rofi" }, ignore_alpha = true },
  { match = { namespace = "notifications" }, blur = true },
  { match = { namespace = "notifications" }, ignore_alpha = true },
  { match = { namespace = "swaync-notification-window" }, blur = true },
  { match = { namespace = "swaync-notification-window" }, ignore_alpha = true },
  { match = { namespace = "swaync-control-center" }, blur = true },
  { match = { namespace = "swaync-control-center" }, ignore_alpha = true },
  { match = { namespace = "logout_dialog" }, blur = true },
})

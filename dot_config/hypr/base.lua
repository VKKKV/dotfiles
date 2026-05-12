hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("LIBVA_DRIVER_NAME", "nvidia")

hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

hl.config({
    input = {
        kb_layout = "us",
        accel_profile = "flat",
        numlock_by_default = true,
        touchpad = {
            natural_scroll = false,
        },
    },

    general = {
        border_size = 0,
        gaps_in = 0,
        gaps_out = 0,
        layout = "dwindle",
        snap = {
            enabled = true,
        },
    },

    dwindle = {
        preserve_split = true,
        force_split = 2,
        smart_split = false,
        smart_resizing = true,
    },

    misc = {
        vrr = 0,
        key_press_enables_dpms = false,
        mouse_move_enables_dpms = false,
        exit_window_retains_fullscreen = true,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        render_unfocused_fps = 60,
    },

    debug = {
        vfr = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    cursor = {
        -- no_hardware_cursors = 1,
        inactive_timeout = 3,
    },

    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.1,
        blur = {
            enabled = true,
        },
        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = false,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sleep 2 && nm-applet --indicator")
    hl.exec_cmd("sleep 2 && blueman-applet")
    hl.exec_cmd("sleep 2 && udiskie --no-automount --smart-tray")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

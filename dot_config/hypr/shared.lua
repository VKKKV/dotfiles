local home = os.getenv("HOME") or ""

return {
  terminal = "ghostty",
  explorer = "thunar",
  browser = "zen-browser",
  src_path = home .. "/.config/hypr/lib",
}

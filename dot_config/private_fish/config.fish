if status is-interactive
    set -gx EDITOR nvim

    set -U fish_greeting ""
    set -gx EDITOR nvim
    set -gx PATH $PATH ./node_modules/.bin $HOME/.local/bin

    alias cp='cp -r'
    alias diff="diff --color=auto"
    alias dt='date "+%Y-%m-%d %H:%M:%S"'
    alias e='exit'
    alias grep="grep --color=auto"
    alias ip="ip -color=auto"
    alias mkdir='mkdir -p'
    alias vim='nvim'
    alias shred='shred -uvz'

    alias gpg='gpg --pinentry-mode loopback'
    alias lg='lazygit'
    alias ta='tmux attach; or tmux'
    alias up='paru -Syu'
    alias zathura='zathura --fork'
    alias mpvhdr='ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk'
    alias dd='dd bs=4M conv=fsync oflag=direct status=progress'
    alias objdump='objdump -M intel'

    starship init fish | source
    zoxide init fish | source
    atuin init fish | source

    fzf --fish | source
    set -gx FZF_TMUX 1
    # set -gx FZF_TMUX_HEIGHT '80%'
    set -gx FZF_COMPLETION_TRIGGER '\\'
    set -gx FZF_DEFAULT_COMMAND  "fd --hidden --strip-cwd-prefix --exclude .git"
    set -gx FZF_DEFAULT_OPTS "--preview '[[ (file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500'"

    # yazi
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        set cwd (cat "$tmp")
        if test -n "$cwd" && test "$cwd" != "$PWD"
            cd "$cwd"
        end
        rm -f -- "$tmp"
    end

    # is.gd URL Shortener
    function shorten
        set -l short_url (curl -s "https://is.gd/create.php?format=simple&url=$argv[1]")
        echo $short_url
        echo -n $short_url | wl-copy
        echo "[Copied to clipboard]"
    end

    function get_cover -d "Random cover extractor"
        if test -z "$argv[1]"
            echo "Error: Missing input file."
            echo "Usage: get_cover <video_file> [output_image]"
            return 1
        end

        set video $argv[1]

        # 检查并设置默认的输出文件名
        if test (count $argv) -ge 2
            set out $argv[2]
        else
            set out "cover.jpg"
        end

        # 获取视频时长
        set duration (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video")

        if test -z "$duration"
            echo "Error: Could not read video duration. Is ffprobe installed?"
            return 1
        end

        # 使用 fish 的 `random` 生成随机种子，并用 awk 计算随机时间点
        set rand_time (awk -v dur=$duration -v seed=(random) 'BEGIN{srand(seed); print rand()*dur}')

        # 调用 ffmpeg 截图
        ffmpeg -hide_banner -loglevel error -ss $rand_time -i "$video" -frames:v 1 -q:v 2 "$out"
        echo "Success! Random frame extracted to $out"
    end
end


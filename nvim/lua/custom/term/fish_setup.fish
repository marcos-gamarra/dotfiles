function n
    # closes (toggles) terminal window in remote nvim instance before opening new file
    nvim --server $NVIM --remote-send "<A-e>"
    nvim --server $NVIM --remote $argv
end

function e 
    z $argv;nvim --server $NVIM --remote-send "<C-\><C-N>:cd $PWD<CR>";nvim --server $NVIM --remote-send "i"
end

function ttn 
    set file_to_open $(fd --type f --hidden --exclude .git |
    fzf --preview "bat --color always {}" \
    --preview-window=top:50% )
    #--bind "super-m:preview-up,super-f:preview-down")

    if test -n "$file_to_open"
        n $file_to_open
    end
end

function ttd
    set dir_to_open $(fd --type d --hidden --exclude .git | 
    fzf --preview "lsd --color always --icon always {}" \
    --preview-window=top:50% \
    --bind "ctrl-m:preview-up,ctrl-f:preview-down")

    if test -n "$dir_to_open"
        e $dir_to_open
    end
end

function ttg
    set rg_command "rg --column --line-number --no-heading --color=always --smart-case " 
    set file_to_open $(fd --type f --hidden --exclude .git |
    fzf --ansi --disabled  \
    --bind "start:reload:$rg_command {q}" \
    --bind "change:reload:sleep 0.1; $rg_command {q} || true"\
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind "ctrl-m:preview-up,ctrl-f:preview-down")

    if test -n "$file_to_open"
        n $file_to_open
    end
end

function ttr 
    if not set -q PROJECT_ROOT_NVIM
        echo "project root not set"
        return 1
    end
    set file_to_open $(fd --type f --hidden --exclude .git --search-path $PROJECT_ROOT_NVIM |
    fzf --preview "bat --color always {}" \
    --preview-window=top:50% )
    #--bind "super-m:preview-up,super-f:preview-down")

    if test -n "$file_to_open"
        n $file_to_open
    end
end

function search_root
    set -f current_search_dir $PWD
    while test "$current_search_dir" != "/";
        set -l results (fd --base-directory $current_search_dir -H -d 1 --no-ignore-vcs "^Cargo.toml\$|^.git\$|^package.json\$")
        if test -n "$results"
            echo $current_search_dir
            return
        end
        set -f current_search_dir (dirname $current_search_dir)
    end
    echo ""
end

function set_project_root
    if not set -q argv[1]
        set -g PROJECT_ROOT_NVIM (search_root)
        if test -z "$PROJECT_ROOT_NVIM"
            set -g PROJECT_ROOT_NVIM $PWD
            echo "Project root not found. Current directory will be used as project root"
        end
    else
        set -g PROJECT_ROOT_NVIM $(realpath $argv[1])
    end
end

# calling this function will set PROJECT_ROOT_NVIM variable
set_project_root

abbr --add n n
abbr --add e e

abbr --add .. e ..
abbr --add ../.. e ../..
abbr --add ../../.. e ../../..

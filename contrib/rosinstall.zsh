# rosinstall zsh completion support. Source this file to get the completion in zsh.


function _roscomplete_rosinstall {
    local opts
    reply=()

    if [[ ${=${(s: :)words}[$(( ${CURRENT} ))]} =~ \-\- ]]; then
      opts="-h --help -n -c --catkin --cmake-prefix-path --continue-on-error --delete-changed-uris --abort-changed-uris --backup-changed-uris --version --nobuild --rosdep-yes --diff --status -j --parallel"
    fi
    reply=(${=opts})
}

compctl -f -K "_roscomplete_rosinstall" "rosinstall"

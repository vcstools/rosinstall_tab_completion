# Software License Agreement (BSD License)
#
# Copyright (c) 2010, Willow Garage, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of Willow Garage, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Author: tkruse 



# Programmable completion for the rosws command under zsh. Source
# this file to get zsh completion help

# put here to be extendable
if [ -z "$ROSWS_BASE_COMMANDS" ]; then
  _ROSWS_BASE_COMMANDS="help init set merge info remove regenerate diff status update --version"
fi

function _roscomplete_rosws {
    local opts
    reply=()

    if [[ ${CURRENT} == 2 ]]; then
        opts=$_ROSWS_BASE_COMMANDS
        reply=(${=opts})
    else
        if [[ ${=${(s: :)words}[$(( ${CURRENT} ))]} =~ \-\- ]]; then
            opts="--help"
            opts=
            case ${=${(s: :)words}[2]} in
            status)
              opts="-t --target-workspace --untracked"
              ;;
            diff)
              opts="-t --target-workspace"
              ;;
            init)
              opts="-c --catkin --cmake-prefix-path -t --target-workspace --continue-on-error"
              ;;
            merge)
              opts="-t --target-workspace -y --confirm-all -r --merge-replace -k --merge-keep -a --merge-kill-append"
              ;;
            set)
              opts="-t --target-workspace --git --svn --bzr --hg --uri -v --version-new --detached -y --confirm"
              ;;
            remove)
              opts="-t --target-workspace"
              ;;
            update)
              opts="-t --target-workspace  --delete-changed-uris --abort-changed-uris --backup-changed-uris"
              ;;
            regenerate)
              opts="-t --target-workspace -c --catkin --cmake-prefix-path"
              ;;
            snapshot)
              opts="-t --target-workspace"
              ;;
            info)
              opts="-t --target-workspace --data-only --no-pkg-path --pkg-path-only --localnames-only --paths-only"
              ;;
            *)
              ;;
            esac
            reply=(${=opts})
        else
            case ${=${(s: :)words}[2]} in
            info|diff|status|remove|update)
              opts=`rosws info --only=localname 2> /dev/null | sed -s 's,:, ,g'`
              reply=(${=opts})
            ;;
            set)
              if [[ ${CURRENT} == 3 ]]; then
                  opts=`rosws info --only=localname 2> /dev/null | sed -s 's,:, ,g'`
                  reply=(${=opts})
              elif [[ ${CURRENT} == 4 ]]; then
                  opts=`rosws info ${=${(s: :)words}[3]} --only=uri 2> /dev/null`
                  reply=(${=opts})
              fi
            ;;
            esac
        fi
    fi

}


compctl -K _roscomplete_rosws + -f  "rosws" "rosws"
#! /usr/bin/env bash

. ./var_undo


# Example script to show how var_undo.sh could be used for ROS setup.sh

##################### first call to setup.sh

echo before
echo $PATH


# restoring (In case if we had stored in the past)
_var_undo_restore_var PATH
echo maybe restored
echo $PATH
echo

_var_undo_backup_var PATH

# sourcing of remote setup.sh
# quotes needed in zsh
export PATH=foo/too:$PATH":bor/gor"
echo added once
echo $PATH
echo 

_var_undo_backup_diff_var PATH
echo backed up
echo $PATH
echo 

# later user additions
export PATH=gaa/saa:$PATH":tar/far"
echo added twice
echo $PATH
echo 

####################### second call to setup.sh

# restoring
_var_undo_restore_var PATH
echo restored
echo $PATH
echo 

_var_undo_backup_var PATH

export PATH="suu/tuu:"$PATH":bur/gur"
echo added once again, different
echo $PATH

_var_undo_backup_diff_var PATH
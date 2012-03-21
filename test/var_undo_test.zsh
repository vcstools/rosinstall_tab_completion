#! /usr/bin/env zsh

. ./var_undo

_var_undo_equal () {
    echo $1 $2 | awk '{ print $1 == $2 }'
}


_runtest () {
    export TEST_VAR="$_test_core"
    if [ -n "$_test_core" -a "$TEST_VAR" != "$_test_core" ]; then
        echo $1 e1 $TEST_VAR; exit 1
    fi
    #### backup original var
    _var_undo_backup_var TEST_VAR
    if [ 0 -eq `_var_undo_equal "$_test_core"  "$TEST_VAR_VAR_UNDO_BACKUP"` ]; then
        echo $1 e2 "$_test_core" != "$TEST_VAR_VAR_UNDO_BACKUP"; exit 2
    fi
    export TEST_VAR="$_test_prefix$TEST_VAR$_test_suffix"
    #### backup changes
    _var_undo_backup_diff_var TEST_VAR
    if [ "$TEST_VAR" != "$_test_prefix$_test_core$_test_suffix" ]; then
        echo $1 e3 "$_test_prefix$_test_core$_test_suffix" != $TEST_VAR; exit 3
    fi
    if [ -z $2 ]; then
        # not testing prefix and suffix in isolation as they are not strictly defined, e.g in "aab" with core "a", suffix could be "ab" or "b".
        if [ -n "$_test_prefix" -a 0 -eq `_var_undo_equal "$TEST_VAR_VAR_UNDO_PREFIX" "$_test_prefix"` ]; then
            echo $1 e4 "$_test_prefix" != $TEST_VAR_VAR_UNDO_PREFIX; exit 1
        fi
        if [ -n "$_test_suffix" -a 0 -eq `_var_undo_equal "$TEST_VAR_VAR_UNDO_SUFFIX" "$_test_suffix"` ]; then
            echo $1 e5 "$_test_suffix" != $TEST_VAR_VAR_UNDO_SUFFIX; exit 4
        fi
    fi
    if [ 0 -eq `_var_undo_equal "$TEST_VAR_VAR_UNDO_PREFIX$_test_core$TEST_VAR_VAR_UNDO_SUFFIX" "$_test_prefix$_test_core$_test_suffix"` ]; then
        echo $1 e7 "$TEST_VAR_VAR_UNDO_PREFIX$_test_core$TEST_VAR_VAR_UNDO_SUFFIX" != "$_test_prefix$_test_core$_test_suffix"; exit 6
    fi
    if [ -n "$_test_core" -a 0 -eq `_var_undo_equal "$TEST_VAR_VAR_UNDO_BACKUP" "$_test_core"` ]; then
        echo $1 e8 "$_test_core" != $TEST_VAR_VAR_UNDO_BACKUP; exit 5
    fi
    export TEST_VAR="$_test_addprefix$TEST_VAR$_test_addsuffix"
    if [ 0 -eq `_var_undo_equal "$TEST_VAR" "$_test_addprefix$_test_prefix$_test_core$_test_suffix$_test_addsuffix"` ]; then
        echo $1 e9 "$_test_addprefix$_test_prefix$_test_core$_test_suffix$_test_addsuffix" != $TEST_VAR; exit 6
    fi
    #### restore
    _var_undo_restore_var TEST_VAR
    if [ 0 -eq `_var_undo_equal "$TEST_VAR" "$_test_addprefix$_test_core$_test_addsuffix"` ]; then
        echo $1 e10 "$_test_addprefix$_test_core$_test_addsuffix" != $TEST_VAR; exit 7
    fi
    echo success $1
}

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 10

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix=""
_test_addsuffix=":tar/far"
_runtest 11

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=""
_runtest 12

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix=""
_test_addsuffix=""
_runtest 13


_test_core="bim/bam:pim/pam"
_test_prefix=""
_test_suffix=":bor/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 20

_test_core="bim/bam:pim/pam"
_test_prefix=""
_test_suffix=":bor/gor"
_test_addprefix=""
_test_addsuffix=":tar/far"
_runtest 21

_test_core="bim/bam:pim/pam"
_test_prefix=""
_test_suffix=":bor/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=""
_runtest 22

_test_core="bim/bam:pim/pam"
_test_prefix=""
_test_suffix=":bor/gor"
_test_addprefix=""
_test_addsuffix=""
_runtest 23


_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=""
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 30

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=""
_test_addprefix="gaa/saa:"
_test_addsuffix=""
_runtest 31

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=""
_test_addprefix=""
_test_addsuffix=":tar/far"
_runtest 32

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=""
_test_addprefix=""
_test_addsuffix=":tar/far"
_runtest 33


_test_core=""
_test_prefix="foo/too:"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 40

_test_core=""
_test_prefix="foo/too:"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix=
_test_addsuffix=":tar/far"
_runtest 41

_test_core=""
_test_prefix="foo/too:"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix="gaa/saa:"
_test_addsuffix=""
_runtest 42

_test_core=""
_test_prefix="foo/too:"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix=""
_test_addsuffix=""
_runtest 43

_test_core=""
_test_prefix=""
_test_suffix=""
_test_addprefix="gaa/saa:"
_test_addsuffix=""
_runtest 44

_test_core=""
_test_prefix=""
_test_suffix=""
_test_addprefix=""
_test_addsuffix=""
_runtest 45


############## test with simple duplicate core

_test_core="bim/bam:pim/pam"
_test_prefix=":bim/bam:pim/pam"
_test_suffix=":bor/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 51 disable_strict

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bim/bam:pim/pam"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 52 disable_strict

_test_core="bim/bam:pim/pam"
_test_prefix=":bim/bam:pim/pam"
_test_suffix=":bim/bam:pim/pam"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 53 disable_strict


_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix=":bim/bam:pim/pam"
_test_addsuffix=":tar/far"
_runtest 54

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix=":bim/bam:pim/pam"
_test_addsuffix=":tar/far"
_runtest 55

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor/gor"
_test_addprefix=":bim/bam:pim/pam"
_test_addsuffix=":bim/bam:pim/pam"
_runtest 56


######## Test for benign behavior with failures

export TEST_VAR=aaa
_var_undo_backup_var TEST_VAR
export TEST_VAR=bbb
_var_undo_backup_diff_var TEST_VAR
_var_undo_restore_var TEST_VAR
 if [ "$TEST_VAR" != "bbb" ]; then
     echo 57 e8 $TEST_VAR; exit 7
 fi
 echo success 57

export TEST_VAR=aaa
_var_undo_backup_var TEST_VAR
export TEST_VAR=bbaaacc
_var_undo_backup_diff_var TEST_VAR
export TEST_VAR=bbb
_var_undo_restore_var TEST_VAR
 if [ "$TEST_VAR" != "bbb" ]; then
     echo 58 e8 $TEST_VAR; exit 7
 fi
 echo success 58

############## Tests against Windows paths

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=";D:\bor\gor"
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=";tar\far"
_runtest 60

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=";D:\bor\gor"
_test_addprefix=""
_test_addsuffix=";tar\far"
_runtest 61

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=";D:\bor\gor"
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=""
_runtest 62

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=";D:\bor\gor"
_test_addprefix=""
_test_addsuffix=""
_runtest 63

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=";D:\bor\gor"
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=";tar\far"
_runtest 70

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=";D:\bor\gor"
_test_addprefix=""
_test_addsuffix=";tar\far"
_runtest 71

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=";D:\bor\gor"
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=""
_runtest 72

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=";D:\bor\gor"
_test_addprefix=""
_test_addsuffix=""
_runtest 73

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=""
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=";tar\far"
_runtest 74

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=""
_test_addprefix=""
_test_addsuffix=";tar\far"
_runtest 75

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=""
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=""
_runtest 76

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix="c:\foo\goo;"
_test_suffix=""
_test_addprefix=""
_test_addsuffix=""
_runtest 77

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=""
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=";tar\far"
_runtest 80

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=""
_test_addprefix=""
_test_addsuffix=";tar\far"
_runtest 81

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=""
_test_suffix=""
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=""
_runtest 82

_test_core="c:\pim\pam;d:\bim\bam"
_test_prefix=";"
_test_suffix=""
_test_addprefix=""
_test_addsuffix=""
_runtest 83

_test_core=""
_test_prefix="c:\foo\goo;"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=":tar/far"
_runtest 90

_test_core=""
_test_prefix="c:\foo\goo;"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix=
_test_addsuffix=":tar/far"
_runtest 91

_test_core=""
_test_prefix="c:\foo\goo;"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix="c:\gaa\saa;"
_test_addsuffix=""
_runtest 92

_test_core=""
_test_prefix="c:\foo\goo;"
_test_suffix="" # if core is empty, there is no notion of pre and suffix
_test_addprefix=""
_test_addsuffix=""
_runtest 93

######## testing against regular expression symbols

_test_core="\pim$^]_-)'?[]|(.?\\\=+\\.*\"pam"
_test_prefix="\foo\\?\|)'$*(.-_=+goo^;"
_test_suffix=";\bor*?(||.[^$'-_\gor"
_test_addprefix="\gaa?^(*\|[\))^|saa;"
_test_addsuffix=";tar/$?^%@]]((*far"
_runtest 94


# tests with /? failed on some occasions
_test_core="bim/bam:pim/pam"
_test_prefix="foo\?/too:"
_test_suffix=":bor/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 95

_test_core="bim/bam:pim/pam"
_test_prefix="foo/too:"
_test_suffix=":bor\?/gor"
_test_addprefix="gaa/saa:"
_test_addsuffix=":tar/far"
_runtest 96
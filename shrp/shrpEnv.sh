#!/bin/bash
##########################################################################
#Copyright 2019 - 2020 SKYHAWK RECOVERY PROJECT
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
##########################################################################

# DEBUG ONLY
#echo "called with these args: $@"

ARGS=$(echo "$@"|tr -d " ")

#kanged from envsetup.sh
function gettop
{
    local TOPFILE=build/make/core/envsetup.mk
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            local T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}
#kanged from envsetup.sh
function get_build_var()
{
    if [ "$BUILD_VAR_CACHE_READY" = "true" ]
    then
        eval "echo \"\${var_cache_$1}\""
    return
    fi

    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP." >&2
        return
    fi
    echo "${!1}"
}

#Delete and create the folder
function resetFolder()
{
    if [ -d "$1" ]; then
        rm -rf $1
    fi;
    mkdir -p $1
}

#Normalize var before send it to a function
function normalizeVar()
{
    if [[ $1 = true ]]; then
        echo true
    else
        echo false
    fi;
}

function addAddonPre()
{
    local INCLUDE_IN_REC=$1
    local ZIPLOC=$2
    local SKIP=$3

    #echo "IncludeIntoRecovery - $1      Location - $2    Skip - $3"

    if [[ $SKIP = false ]]; then
        if $INCLUDE_IN_REC; then
            echo "Saving $ZIPLOC into recovery-image"
            mkdir -p $REC_OUT/twres/addons/
            cp -a "$ZIPLOC" "$REC_OUT/twres/addons/"
        fi;
    fi;
}


#helper functions for addon system
function addAddonPost()
{
    local INCLUDE_IN_REC=$1
    local ZIPLOC=$2
    local SKIP=$3

    if [[ $SKIP = false ]]; then
        if [[ $INCLUDE_IN_REC != true ]]; then
            echo "Saving $ZIPLOC into zip"
            mkdir -p $SHRP_WORK_DIR/Files/SHRP/addons/
            cp -a "$ZIPLOC" "$SHRP_WORK_DIR/Files/SHRP/addons/"
        fi;
    fi;
}

function addDefaultAddonPre()
{
    local INCLUDE_IN_REC=$1
    local ZIPLOC=$2
    local EXCLUDE_ADDON=$3
    local SKIPMAIN=$4

    #echo "IncludeIntoRecovery - $1      Location - $2    Skip - $3"
    if [[ $SKIPMAIN = true ]]; then
        echo "Skipping $ZIPLOC"
    elif [[ $EXCLUDE_ADDON = true ]]; then
        echo "Skipping $ZIPLOC"
    else
        if $INCLUDE_IN_REC; then
            echo "Saving $ZIPLOC into recovery-image"
            mkdir -p $REC_OUT/twres/addons/
            cp -a "$ZIPLOC" "$REC_OUT/twres/addons/"
        fi;
    fi;
}

function addDefaultAddonPost()
{
    local INCLUDE_IN_REC=$1
    local ZIPLOC=$2
    local EXCLUDE_ADDON=$3

    #echo "IncludeIntoRecovery - $1      Location - $2    Skip - $3"

    if [[ $SKIPMAIN = true ]]; then
        echo "Skipping $ZIPLOC"
    elif [[ $EXCLUDE_ADDON = true ]]; then
        echo "Skipping $ZIPLOC"
    else
        if [[ $INCLUDE_IN_REC != true ]]; then
            echo "Saving $ZIPLOC into zip"
            mkdir -p $SHRP_WORK_DIR/Files/SHRP/addons/
            cp -a "$ZIPLOC" "$SHRP_WORK_DIR/Files/SHRP/addons/"
        fi;
    fi;
}

function get_addon_confirm()
{
    if [ -f $1 ]; then
        echo $1
    else
        echo false
    fi;
}

function addon_skip()
{
    if [ -f $1 ]; then
        echo false
    else
        echo true
    fi;
}


function getSize()
{
    if [ -f $1 ]; then
        echo $(expr $(stat -c %s $1) / 1048576)MB
    else
        echo "N/A"
    fi;
}

#COMMON VARS
SHRP_BUILD_DATE_F=$(echo "$ARGS" | cut -d "," -f 1)
SHRP_BUILD_DATE="${SHRP_BUILD_DATE_F/*@/}"
SHRP_MAINTAINER=$(echo "$ARGS" | cut -d "," -f 2)
SHRP_DEVICE=$(echo "$ARGS" | cut -d "," -f 3)
SHRP_OFFICIAL=$(echo "$ARGS" | cut -d "," -f 4)
SHRP_EXPRESS=$(echo "$ARGS" | cut -d "," -f 5)
SHRP_DARK=$(echo "$ARGS" | cut -d "," -f 6)
SHRP_ALT_REBOOT=$(echo "$ARGS" | cut -d "," -f 7)

SHRP_REC=$(echo "$ARGS" | cut -d "," -f 8)
SHRP_AB=$(echo "$ARGS" | cut -d "," -f 9)
tool="/data/local/twrp-install/magiskboot"
target="/data/local/twrp-install/boot.img"
REC_OUT=$(echo "$ARGS" | cut -d "," -f 10)
EAP=$(echo "$ARGS" | cut -d "," -f 11)

SHRP_EXCLUDE_DEFAULT_ADDONS=$(echo "$ARGS" | cut -d "," -f 12)
SHRP_SKIP_DEFAULT_ADDON_1=$(echo "$ARGS" | cut -d "," -f 13)
SHRP_SKIP_DEFAULT_ADDON_2=$(echo "$ARGS" | cut -d "," -f 14)
SHRP_SKIP_DEFAULT_ADDON_3=$(echo "$ARGS" | cut -d "," -f 15)
SHRP_SKIP_DEFAULT_ADDON_4=$(echo "$ARGS" | cut -d "," -f 16)
SHRP_EXTERNAL_ADDON_1_FILENAME=$(echo "$ARGS" | cut -d "," -f 17)
SHRP_EXTERNAL_ADDON_2_FILENAME=$(echo "$ARGS" | cut -d "," -f 18)
SHRP_EXTERNAL_ADDON_3_FILENAME=$(echo "$ARGS" | cut -d "," -f 19)
SHRP_EXTERNAL_ADDON_4_FILENAME=$(echo "$ARGS" | cut -d "," -f 20)
SHRP_EXTERNAL_ADDON_5_FILENAME=$(echo "$ARGS" | cut -d "," -f 21)
SHRP_EXTERNAL_ADDON_6_FILENAME=$(echo "$ARGS" | cut -d "," -f 22)
SHRP_INC_IN_REC_EXTERNAL_ADDON_1=$(echo "$ARGS" | cut -d "," -f 23)
SHRP_INC_IN_REC_EXTERNAL_ADDON_2=$(echo "$ARGS" | cut -d "," -f 24)
SHRP_INC_IN_REC_EXTERNAL_ADDON_3=$(echo "$ARGS" | cut -d "," -f 25)
SHRP_INC_IN_REC_EXTERNAL_ADDON_4=$(echo "$ARGS" | cut -d "," -f 26)
SHRP_INC_IN_REC_EXTERNAL_ADDON_5=$(echo "$ARGS" | cut -d "," -f 27)
SHRP_INC_IN_REC_EXTERNAL_ADDON_6=$(echo "$ARGS" | cut -d "," -f 28)
INC_IN_REC_MAGISK=$(echo "$ARGS" | cut -d "," -f 29)
SHRP_HAS_RECOVERY_PARTITION=$(echo "$ARGS" | cut -d "," -f 30)
IS_OFFICIAL=$(echo "$ARGS" | cut -d "," -f 31)
INC_IN_REC_ADDON_1=$(echo "$ARGS" | cut -d "," -f 32)
INC_IN_REC_ADDON_2=$(echo "$ARGS" | cut -d "," -f 33)
INC_IN_REC_ADDON_3=$(echo "$ARGS" | cut -d "," -f 34)
INC_IN_REC_ADDON_4=$(echo "$ARGS" | cut -d "," -f 35)
SHRP_LITE=$(echo "$ARGS" | cut -d "," -f 36)

SHRP_VERSION=3.1
SHRP_STATUS=stable

SHRP_VENDOR=vendor/shrp
MAGISKBOOT=$SHRP_VENDOR/magiskboot/magiskboot
SHRP_BUILD=build/make/shrp
SHRP_OUT=$OUT
SHRP_WORK_DIR=$OUT/zip
SHRP_META_DATA_DIR=$OUT/zip/META-INF
RECOVERY_IMG=$OUT/recovery.img
RECOVERY_RAM=$OUT/ramdisk-recovery.cpio

if [ "$IS_OFFICIAL" == "1" ] && [ "$SHRP_OFFICIAL" == "true" ]; then
    XSTATUS=Official
else
    XSTATUS=Unofficial
fi;

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
    (\cd $T; build/soong/soong_ui.bash --dumpvar-mode $1)
}
#check official or not
function o_or_not()
{
oc=false
hello=$(curl -s https://raw.githubusercontent.com/SHRP-Devices/device_data/master/devices.raw)
IFS=','
read -a arr <<< "$hello"

for val in "${arr[@]}" 
do
    if [[ $val = $2 ]]; then
        oc=true
        break
    fi
done
if [[ $1 = $oc ]]; then
echo true
else
echo false
fi;
}

#check official or not
#function o_or_not()
# {
#oc=false
#hello=$(curl -s https://raw.githubusercontent.com/SHRP-Devices/device_data/master/devices)
#IFS=$'\n';
#devices=($hello);
#
#for device in "${devices[@]}" 
#do
#    if [[ $device = $2 ]]; then
#        oc=true
#        break
#    fi
#done
#if [[ $1 = $oc ]]; then
#echo true
#else
#echo false
#fi;
#}

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
SHRP_BUILD_DATE=$(get_build_var SHRP_BUILD_DATE)
SHRP_MAINTAINER=$(get_build_var SHRP_MAINTAINER)
SHRP_DEVICE=$(get_build_var SHRP_DEVICE_CODE)
SHRP_OFFICIAL=$(get_build_var SHRP_OFFICIAL)
SHRP_EXPRESS=$(get_build_var SHRP_EXPRESS)
SHRP_DARK=$(get_build_var SHRP_DARK)
SHRP_ALT_REBOOT=$(get_build_var SHRP_ALT_REBOOT)
IS_OFFICIAL=$(o_or_not $SHRP_OFFICIAL $SHRP_DEVICE)

SHRP_REC=$(get_build_var SHRP_REC)
SHRP_AB=$(get_build_var SHRP_AB)
tool="/data/local/twrp-install/magiskboot"
target="/data/local/twrp-install/boot.img"
REC_OUT=$(get_build_var TARGET_RECOVERY_ROOT_OUT)
EAP=$(get_build_var SHRP_EXTERNAL_ADDON_PATH)

SHRP_VERSION=3.69
SHRP_STATUS=beta


SHRP_VENDOR=vendor/shrp
MAGISKBOOT=$SHRP_VENDOR/extras/magiskboot
SHRP_BUILD=build/make/shrp
SHRP_OUT=$OUT
SHRP_WORK_DIR=$OUT/zip
SHRP_META_DATA_DIR=$OUT/zip/META-INF
RECOVERY_IMG=$OUT/recovery.img
RECOVERY_RAM=$OUT/ramdisk-recovery.cpio

if $IS_OFFICIAL; then
    XSTATUS=Official
else
    XSTATUS=Unofficial
fi;

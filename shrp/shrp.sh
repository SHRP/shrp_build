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

# Get current working dir
#
dir="$(pwd)"

# DEBUG ONLY
#echo "$0 called with these args: $@"

#initializing helper function
. "${dir}"/build/shrp/shrpEnv.sh "$@"

#
# Run shrp env variables from here
#
DEFAULT_ADDON_LOC="${dir}"/$SHRP_VENDOR/extras

#handle default Addons
addDefaultAddonPre $(normalizeVar $(get_build_var INC_IN_REC_ADDON_1)) $DEFAULT_ADDON_LOC/s_oms.zip $(normalizeVar $(get_build_var SHRP_SKIP_DEFAULT_ADDON_1)) $(normalizeVar $(get_build_var SHRP_EXCLUDE_DEFAULT_ADDONS))
addDefaultAddonPre $(normalizeVar $(get_build_var INC_IN_REC_ADDON_2)) $DEFAULT_ADDON_LOC/s_non_oms.zip $(normalizeVar $(get_build_var SHRP_SKIP_DEFAULT_ADDON_2)) $(normalizeVar $(get_build_var SHRP_EXCLUDE_DEFAULT_ADDONS))
addDefaultAddonPre $(normalizeVar $(get_build_var INC_IN_REC_ADDON_3)) $DEFAULT_ADDON_LOC/rfp.zip $(normalizeVar $(get_build_var SHRP_SKIP_DEFAULT_ADDON_3)) $(normalizeVar $(get_build_var SHRP_EXCLUDE_DEFAULT_ADDONS))
addDefaultAddonPre $(normalizeVar $(get_build_var INC_IN_REC_ADDON_4)) $DEFAULT_ADDON_LOC/Disable_Dm-Verity_ForceEncrypt.zip $(normalizeVar $(get_build_var SHRP_SKIP_DEFAULT_ADDON_4)) $(normalizeVar $(get_build_var SHRP_EXCLUDE_DEFAULT_ADDONS))

addDefaultAddonPre $(normalizeVar $(get_build_var INC_IN_REC_MAGISK)) $DEFAULT_ADDON_LOC/c_magisk.zip false false
addDefaultAddonPre $(normalizeVar $(get_build_var INC_IN_REC_MAGISK)) $DEFAULT_ADDON_LOC/unmagisk.zip false false
#handle External Addons
addAddonPre $(normalizeVar $(get_build_var SHRP_INC_IN_REC_EXTERNAL_ADDON_1)) $(get_addon_confirm ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_1_FILENAME)) $(addon_skip ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_1_FILENAME))
addAddonPre $(normalizeVar $(get_build_var SHRP_INC_IN_REC_EXTERNAL_ADDON_2)) $(get_addon_confirm ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_2_FILENAME)) $(addon_skip ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_2_FILENAME))
addAddonPre $(normalizeVar $(get_build_var SHRP_INC_IN_REC_EXTERNAL_ADDON_3)) $(get_addon_confirm ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_3_FILENAME)) $(addon_skip ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_3_FILENAME))
addAddonPre $(normalizeVar $(get_build_var SHRP_INC_IN_REC_EXTERNAL_ADDON_4)) $(get_addon_confirm ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_4_FILENAME)) $(addon_skip ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_4_FILENAME))
addAddonPre $(normalizeVar $(get_build_var SHRP_INC_IN_REC_EXTERNAL_ADDON_5)) $(get_addon_confirm ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_5_FILENAME)) $(addon_skip ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_5_FILENAME))
addAddonPre $(normalizeVar $(get_build_var SHRP_INC_IN_REC_EXTERNAL_ADDON_6)) $(get_addon_confirm ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_6_FILENAME)) $(addon_skip ${dir}/$EAP$(get_build_var SHRP_EXTERNAL_ADDON_6_FILENAME))

#Saving Version Directly in out
echo $SHRP_BUILD_DATE > $REC_OUT/twres/version

if [[ $SHRP_AB = true ]]; then
    cp "${dir}"/vendor/shrp/magiskboot/magiskbootnt $REC_OUT/sbin/
fi;

if [[ $SHRP_DARK = true ]]; then
cp -r "${dir}"/bootable/recovery/gui/theme/shrp_dark/* $REC_OUT/twres/
fi;

if [[ $SHRP_LITE = true ]]; then
rm -rf $REC_OUT/twres/themeResources
fi;

if [[ $SHRP_ALT_REBOOT = true ]]; then
cp -r "${dir}"/bootable/recovery/gui/theme/extra-layouts/altPower/* $REC_OUT/twres/
fi;

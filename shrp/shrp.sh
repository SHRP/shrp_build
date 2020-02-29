# !/bin/bash
##########################################################################
#Copyright 2019 SKYHAWK RECOVERY PROJECT
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
#
# Run shrp env variables from here
#
SHRP_MAINTAINER=$(sed -n '1p' "$(pwd)/build/shrp/variables")
SHRP_DEVICE=$(sed -n '2p' "$(pwd)/build/shrp/variables")
SHRP_REC=$(sed -n '3p' "$(pwd)/build/shrp/variables")

cat > "${dir}"/build/shrp/shrp_vital <<EOF
ro.shrp.recovery.block=$SHRP_REC
EOF

cat > "${dir}"/build/shrp/updater-script <<EOF
show_progress(1.000000, 0);
ui_print("             ");
ui_print("Skyhawk Recovery Project                  ");
ui_print("|SHRP version - 2.2 Stable                ");
ui_print("|Device - $SHRP_DEVICE");
ui_print("|Maintainer - $SHRP_MAINTAINER");
delete_recursive("/sdcard/SHRP");
package_extract_dir("Files", "/sdcard/");
set_progress(0.500000);
package_extract_file("recovery.img", "$SHRP_REC");
set_progress(0.700000);
ui_print("                                                  ");
ui_print("Credits,                                          ");
ui_print(" TeamSHRP - epicX | Dni9 | Giovix 92              ");
ui_print(" Thanks to -                                      ");
ui_print("  + osmOsis for various scripts                   ");
ui_print("  + Teamwin for TWRP                              ");
ui_print("  + Topjohnwu for Magisk                          ");
ui_print("  + VR25 for Magisk mount scripts                 ");
ui_print("  + Mauronofrio for TWRP Survival                 ");
ui_print("  + DarthJabba9 for /data fix                     ");
ui_print("  + Pritish joshi for translation                 ");
ui_print("  + Kirill for translation                        ");
ui_print("  + Burak D. for translation                      ");
ui_print("  + ZJRDroid for translation                      ");
ui_print("  + LayeardDevMod for translation                 ");
ui_print("                                                  ");
ui_print("Contact Us,");
ui_print(" + Website- http://shrp.cf                        ");
ui_print(" + Telegram Group - t.me/sky_hawk                 ");
ui_print(" + Telegram Channel - t.me/shrp_official          ");
set_progress(1.000000);
ui_print("");
EOF

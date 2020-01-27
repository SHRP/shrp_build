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

tool="/data/local/twrp-install/magiskboot"
target="/data/local/twrp-install/boot.img"

cat > "${dir}"/build/shrp/update-binary-b <<EOF
show_progress(1.000000, 0);
ui_print("             ");
ui_print("Skyhawk Recovery Project                     ");
ui_print("|SHRP version - 2.2 Beta                     ");
ui_print("|Device - $SHRP_DEVICE");
ui_print("|Maintainer - $SHRP_MAINTAINER");
delete_recursive("/sdcard/SHRP");
package_extract_dir("Files", "/sdcard/");
set_progress(0.500000);
EOF

cat > "${dir}"/build/shrp/update-binary-c <<EOF
tool="/data/local/twrp-install/magiskboot"
dd if=/dev/block/bootdevice/by-name/boot_a "of=$target"
"$tool" unpack -h boot.img
cp -f ramdisk-recovery.cpio ramdisk.cpio
"$tool" repack boot.img new-boot.img
dd if=new-boot.img of=/dev/block/bootdevice/by-name/boot_a
rm boot.img
rm dtb
rm kernel
rm new-boot.img
rm ramdisk.cpio
ui_print("Running boot image patcher on slot B...");
dd if=/dev/block/bootdevice/by-name/boot_b "of=$target"
"$tool" unpack -h boot.img
cp -f ramdisk-recovery.cpio ramdisk.cpio
"$tool" repack boot.img new-boot.img
dd if=new-boot.img of=/dev/block/bootdevice/by-name/boot_b
sleep(1);

EOF

cat > "${dir}"/build/shrp/update-binary-d <<EOF
set_progress(0.700000);
ui_print("                                                  ");
ui_print("Credits,                                          ");
ui_print(" TeamSHRP - epicX | Dni9 | Giovix 92              ");
ui_print(" Thanks to -                                      ");
ui_print("  + osmOsis for various scripts                   ");
ui_print("  + Teamwin for TWRP                              ");
ui_print("  + Topjohnwu for Magisk                          ");
ui_print("  + VR25 for Magisk mount scripts                 ");
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

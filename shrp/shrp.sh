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
source "${dir}"/build/shrp/shrp_env.sh

cat > "${dir}"/build/shrp/c_ex_variables.xml <<EOF
<?xml version="1.0"?>
<recovery>
	<details>
		<resolution width="1080" height="1920"/>
		<author>Teamwin | epicX</author>
		<title>SKY HAWK RECOVERY PROJECT</title>
		<description>Only_here_you_need_to_change_your_values</description>
		<preview>preview.png</preview>
		<themeversion>3</themeversion>
	</details>
	<variables>
		<variable name="usb_otg_location" value="$SHRP_OTG"/>
		<variable name="external_storage_location" value="$SHRP_EXTERNAL"/>
		<variable name="device_code_name" value="$SHRP_DEVICE"/>
		<variable name="device_maintainer_name" value="$SHRP_MAINTAINER"/>
		<variable name="has_edl_mode" value="$SHRP_EDL_MODE"/>
		<variable name="has_flashlight" value="$SHRP_FLASH"/>
	</variables>
	<templates>
		<template name="flashlight">
			<button>
				<conditions>
					<condition var1="has_flashlight" op="=" var2="1"/>
					<condition var1="c_flashlight_status" op="=" var2="0"/>
				</conditions>
				<placement x="975" y="1814"/>
				<image resource="c_flashlight_on"/>
				<action function="flashlight"/>
			</button>
			<button>
				<conditions>
					<condition var1="has_flashlight" op="=" var2="1"/>
					<condition var1="c_flashlight_status" op="=" var2="1"/>
				</conditions>
				<placement x="35" y="1814"/>
				<image resource="c_flashlight_off"/>
				<action function="flashlight"/>
			</button>
		</template>
	</templates>
</recovery>
EOF

cat > "${dir}"/build/shrp/shrp_vital <<EOF
ro.shrp.recovery.block=$SHRP_REC
EOF

cat > "${dir}"/build/shrp/updater-script <<EOF
show_progress(1.000000, 0);
ui_print("                                            _ _ __");
ui_print("   __ __ __  _ __ _  __ _            __   /_ _   /");
ui_print("  / _ _// / / / __ \/ __ \   __     / /   _ __/ / ");
ui_print("  \__ \/ /_/ / /_/ / /_/ /   \ \   / /  / _ _ _/  ");
ui_print(" ___/ / __  / _, _/ ____/     \ \_/ /  / /_ _     ");
ui_print("/__ _/_/ /_/_/ |_/_/           \__ /  /__ __/     ");
ui_print("                                                  ");
ui_print("                                                  ");
ui_print("                                                  ");
sleep(2);
ui_print("Skyhawk Recovery Project                          ");
ui_print("--------------------------------------------------");
ui_print("Details-                                          ");
ui_print("SHRP version - 2.1 Stable                         ");
ui_print("Device - $SHRP_DEVICE");
ui_print("Maintainer - $SHRP_MAINTAINER");
ui_print("                                                  ");
ui_print("                                                  ");
ui_print("Installing Addons...");
ui_print("--------------------------------------------------");
package_extract_dir("Files", "/sdcard/");
set_progress(0.500000);
ui_print("                                                  ");
ui_print("                                                  ");
sleep(2);
ui_print("Flashing Recovery...");
ui_print("--------------------------------------------------");
package_extract_file("Files/SHRP/epicx/recovery.img", "$SHRP_REC");
sleep(1);
ui_print("                                                  ");
ui_print("                                                  ");
set_progress(0.700000);
ui_print("Installation Completed                            ");
ui_print("--------------------------------------------------");
ui_print("                                                  ");
ui_print("                                                  ");
ui_print("Credits,                                          ");
ui_print("--------------------------------------------------");
ui_print("                                                  ");
ui_print("epicX | Dni9 | osmOsis | Teamwin | VR25           ");
ui_print("                                                  ");
ui_print("                                                  ");
ui_print("Special thanks to,                                ");
ui_print("--------------------------------------------------");
ui_print("                                                  ");
ui_print("Pritish joshi | Giovix92 | Kirill | Others        ");
ui_print("                                                  ");
ui_print("                                                  ");
ui_print("Contact Us,                       ");
ui_print("--------------------------------------------------");
ui_print("Our Website- http://shrp.cf                       ");
ui_print("Our Telegram Group- t.me/sky_hawk                 ");
ui_print("YT Channel- youtube.com/epicspicy                 ");
set_progress(1.000000);
ui_print("");
EOF

cp "${dir}"/build/shrp/c_ex_variables.xml "${dir}"/bootable/recovery/gui/theme/shrp_portrait_hdpi/

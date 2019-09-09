# !/bin/bash

cat > ~/twrp/build/shrp/c_ex_variables.xml <<EOF
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
		<variable name="internal_storage_location" value="$SHRP_INTERNAL"/>
		<variable name="device_code_name" value="$SHRP_DEVICE"/>
		<variable name="device_maintainer_name" value="$SHRP_MAINTAINER"/>
		<variable name="shrp_ver" value="V2.1"/>
		<variable name="shrp_ver_status" value="Stable"/>
		<variable name="has_edl_mode" value="$SHRP_EDL_MODE"/>
		<variable name="has_flashlight" value="$SHRP_FLASH"/>
	</variables>
	<templates>
		<template name="flashlight">
			<button>
				<condition var1="has_flashlight" op="=" var2="1"/>
				<placement x="975" y="1814"/>
				<image resource="c_flashlight_on"/>
				<actions>
					<action function="cmd">
$SHRP_FONP_1
$SHRP_FONP_2
$SHRP_FONP_3
					</action>
				</actions>
			</button>
			<button>
				<condition var1="has_flashlight" op="=" var2="1"/>
				<placement x="35" y="1814"/>
				<image resource="c_flashlight_off"/>
				<actions>
					<action function="cmd">
$SHRP_FOFP_1
$SHRP_FOFP_2
$SHRP_FOFP_3
					</action>
				</actions>
			</button>
		</template>
	</templates>
</recovery>
EOF

cat > ~/twrp/build/shrp/shrp_vital.xml <<EOF
ro.shrp.recovery.block=$SHRP_REC
EOF

cat > ~/twrp/build/shrp/updater-script <<EOF
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
ui_print("Device - $SHRP_DEVICE_CODE");
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

cp ~/twrp/build/shrp/c_ex_variables.xml ~/twrp/bootable/recovery/gui/theme/shrp_portrait_hdpi/

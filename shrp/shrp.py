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

from pathlib import Path
from os import system
from time import sleep

class clr:
    CL_RED='\033[31m'
    CL_GRN='\033[32m'
    CL_YLW='\033[33m'
    CL_BLU='\033[34m'
    CL_MAG='\033[35m'
    CL_CYN='\033[36m'
    CL_RST='\033[0m'


currPath = str(Path().absolute())
devicePath = ""
devices = []

if currPath.find("build") != -1:
    devicePath = "."

devicePath += "."



def init():
    global devicePath
    global devices

    devices.clear()
    
    p = Path(devicePath + "/device").glob("*")

    for path in p:
        if str(path).find("generic") == -1 and path.is_dir():
            pathDevices = getDeviceList(str(path))
            for pathDevice in pathDevices:
                devices.append(pathDevice)



#Functions
def getDeviceList(path):
    tmp = Path(path).glob("*")
    devices = []

    for pp in tmp:

        if pp.is_dir():
            device = str(pp)
            device = device[device.rfind("/")+1:]

            devices.append(device)

    return devices



def dirtyBuildPossible(path):
    if Path(path).exists():
        return True
    else:
        return False



def build(deviceName, rPath, buildMode):
    exitCode = 0
    if buildMode == 1:

        exitCode = system(f'export DEVICE={deviceName};export MODE={buildMode};bash {rPath}/build/shrp/build.sh')

        
    
    if buildMode == 2:
        exitCode = system(f'export DEVICE={deviceName};export MODE={buildMode};bash {rPath}/build/shrp/build.sh')
        
    

    if exitCode == 0:
        print('\x1b[6;30;42m' + " Build Success " + '\x1b[0m')
        sleep(.5)
        print("\nDo you want to rebuild??\n")
    else:
        print('\x1b[6;30;31m' + "Failed due to some reason" + '\x1b[0m')
        sleep(.5)
        print("\nDo you want to retry??\n")
        
        
    print(f'{clr.CL_CYN}1.{clr.CL_RST} Clean Build\n')
    print(f'{clr.CL_CYN}2.{clr.CL_RST} Dirty Build\n')
    print(f'{clr.CL_CYN}3.{clr.CL_RST} Exit\n')

    x = int(input("Input - "))
    system("clear")
    return x




def exitHelper():
    print("\nDo you want to retry??")
    print(f'{clr.CL_CYN}1.{clr.CL_RST} Clean Build\n')
    print(f'{clr.CL_CYN}2.{clr.CL_RST} Dirty Build\n')
    print(f'{clr.CL_CYN}3.{clr.CL_RST} Exit\n')
    return int(input("Input - "))



def main():
    global devicePath
    system("clear")
    sleep(.5)
    print(f'--------------------------------------------------\n{clr.CL_CYN}SHRP BUILDER{clr.CL_RST}\nFor which device you want to build SHRP?\nIF there is not device showing then put device tree first.\n--------------------------------------------------\n\nAvailable Devices -\n{clr.CL_RST}')
    count = 1
    if len(devices) == 0:
        print(f'{clr.CL_RED}No devices are available.\nKindy Put Device Tree into device/<manufacturerName>/<deviceCodeName>{clr.CL_RST}\n')
        return
    
    for device in devices:
        print(f'{clr.CL_RED}{count}. {clr.CL_RST}{device}\n')
        count += 1


    selectedDevice = int(input('Select from 1 to ' + str(count-1) + " - ")) - 1

    system('clear')
    if selectedDevice < 0 or selectedDevice >= count - 1:
        return


    outDir = devicePath+"/out/target/product/"+devices[selectedDevice]+"/"

    print(f'\nAvailable build options - \n')
    print(f'{clr.CL_CYN}1.{clr.CL_RST} Clean Build\n')
    print(f'{clr.CL_CYN}2.{clr.CL_RST} Dirty Build\n')
        
    buildMode = int(input("Input - "))

    system('clear')
    sleep(.5)

    

    while True:
        tmp = 0
        #print(f'DEBUG - {devices[selectedDevice]}\t{devicePath}\t{buildMode}\t{outDir}')
        if buildMode == 1:
            print(f'{clr.CL_CYN}\nBuild Starts....{clr.CL_RST}\n')
            sleep(.5)
            tmp = build(devices[selectedDevice], devicePath, buildMode)
        elif buildMode == 2 and dirtyBuildPossible(outDir):
            print(f'{clr.CL_CYN}\nBuild Starts....{clr.CL_RST}\n')
            sleep(.5)
            tmp = build(devices[selectedDevice], devicePath, buildMode)
        else:
            print(f'{clr.CL_CYN}\nBuild Starts....{clr.CL_RST}\n')
            sleep(.5)
            print("Dirty build not possible because you didnt compiled for this device yet.\nHint - Do a clean build then try dirty build.\nThank You...")
            tmp = exitHelper()

        if tmp == 1:
            buildMode = 1
        elif tmp == 2:
            buildMode = 2
        else:
            break

    


def display():
    system("clear")
    print('''



                                ▄▄████████▄▄╓_          ,▄█████▄_

                             ▄██████████████████▄▄,╓▄▄████████▀▀▀

                  _     _╓▄███████████████████████████████▀▀

                  `▀▀████████████▀▀-     ,██████████████▀

                         -"'"        _▄▄████████████▀'

                           __,▄▄▄▄████████████▀▀"

                    ,▄▄██████████▀▀▀▀

              _╓æ▀▀",
    ''')
    sleep(.5)



while True:
    display()
    init()
    main()
    x = int(input("Reload or Exit? \n 1.Reload\t2.Exit\nInput - "))

    if x != 1 :
        system("clear")
        break














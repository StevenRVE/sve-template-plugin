#!/bin/sh

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

############################################################
# Help                                                     #
############################################################

help()
{
        # Display Help
        echo "This is the help option for builder.sh. "
        echo
        echo "Syntax: build.sh [-c|b|i|a|l]"
        echo "options:"
        echo "c      clear cached files in mod workdir"
        echo "b      build plugin using mod plugin builder"
        echo "i      install plugin from workdir to moddwarf"
        echo "a      run build and install function"
	echo "l      build and run local"
}

############################################################
# Clear cached files                                       #
############################################################

clear()
{
    # remove cached build/tmp files
    rm -r ~/mod-workdir/moddwarf/build/host-sve-sequencer-dpf-labs-custom/
    rm -r ~/mod-workdir/moddwarf/build/sve-sequencer-dpf-labs-*
    rm -r ~/mod-workdir/moddwarf/host/tmp-sve-sequencer-dpf-labs
    rm -r ~/mod-workdir/moddwarf/plugins/SVE-Sequencer.lv2
    rm -r ~/mod-workdir/moddwarf/target/lib/lv2/SVE-Sequencer.lv2
    rm -r ~/mod-plugin-builder/plugins/package/sve-sequencer-dpf-labs

    make clean

    echo "${GREEN}cached files succesfully cleared${NC}"
}

############################################################
# Build                                                    #
############################################################

build()
{
    clear

    # copy plugin dir in mod-plugin-builder plugins directory
    cp -r ~/Development/sve-plugins/sve-sequencer-dpf-labs/ ~/mod-plugin-builder/plugins/package/

    # build plugin
    cd ~/mod-plugin-builder/
    ./build moddwarf sve-sequencer-dpf-labs/
    cd -

    # copy .ttl files to mod workdir
    make
    cp -r ~/Development/sve-plugins/sve-sequencer-dpf-labs/source/build/SVE-Sequencer.lv2/*.ttl ~/mod-workdir/moddwarf/plugins/SVE-Sequencer.lv2/

    echo "${GREEN}build function is completed!${NC}"

    # remove the old plugin version
    rm -r ~/.lv2/SVE-Sequencer.lv2

    echo "${GREEN}removed old lv2 plugin${NC}"

    # copy complete lv2 plugin to .lv2 directory
    cp -r ~/mod-workdir/moddwarf/plugins/SVE-Sequencer.lv2 ~/.lv2

    echo "${GREEN}copied new lv2 plugin${NC}"
}

############################################################
# Install                                                  #
############################################################

install()
{
    # install plugin on moddwarf
    cd ~/mod-workdir/moddwarf/plugins
    tar cz SVE-Sequencer.lv2 | base64 | curl -F 'package=@-' http://192.168.51.1/sdk/install
    cd -

    echo "${GREEN}install function is completed!${NC}"
}

############################################################
# All                                                      #
############################################################

all()
{
    build
    install
    echo "${GREEN}all function is completed!${NC}"
}

############################################################
# Build/run local lv2                                      #
############################################################

localLV2()
{
    rm -rf ~/.lv2/SVE-Sequencer.LV2 || true
    make
    cp -r build/SVE-Sequencer.lv2/ ~/.lv2
    make clean
    gnome-terminal -- qjackctl& -s
    echo "${GREEN}Qjackctl is running!${NC}"
    echo "${ORANGE}Make sure to turn on transport${NC}"
    jalv.gtk3 https://github.com/StevenRVE/sve-plugins/sve-sequencer-dpf
    echo "${GREEN}localLV2 plugin is running!${NC}"
}

############################################################
# handling options                                         #
############################################################

while getopts ":abchil" option; do
    case $option in
        a)  # run all function
            all
            exit;;
        b)  # run build function
            build
            exit;;
        c)  # run clear function
            clear
            exit;;
        h) # display Help
            help
            exit;;
        i)  # run install function
            install
            exit;;
        l)  # build/run local lv2
            localLV2
            exit;;
       \?) # Invalid option
           echo "${RED}Error: Invalid option${NC}"
           exit;;
    esac
done

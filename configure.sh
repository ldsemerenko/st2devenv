#!/bin/bash


BOOTSTRAPMODS_DIR=bootstrap-mods
BOOTSTRAPMODS_ACTIVE_DIR=bootstrap-mods-active

print_usage()
{
    echo "usage: configure.sh <targetvm>"
    echo ""
    echo "where target is one of:"
    echo "      stackaton    setup the vm for the stackaton demo"
    echo "      clean        empty the $BOOTSTRAPMODS_ACTIVE_DIR folder"
    exit -1
}

activate()
{
    if [ "$#" -ne "1" ]; then
        echo "error: activate function takes one argument"
        exit -1
    fi
    SCRIPT=$1

    if [ ! -e $BOOTSTRAPMODS_DIR/$SCRIPT ]; then
        echo "error: script '$SCRIPT' does not exist"
        exit -1
    fi

    ln -s ../$BOOTSTRAPMODS_DIR/$SCRIPT $BOOTSTRAPMODS_ACTIVE_DIR
}


if [ "$#" != "1" ]; then
    print_usage
fi

if [ -e "./Vagrantfile" ]; then
    mkdir $BOOTSTRAPMODS_ACTIVE_DIR > /dev/null 2>&1
fi

# Clean up the active directory
find $BOOTSTRAPMODS_ACTIVE_DIR -type l -print0 | xargs -0 rm -f

if [ "$#" -ne "0" ]; then
    while [ "$#" -gt "0" ]; do
        case $1 in
            stackaton)
                activate codedir.sh
                activate disablefirewall.sh
                activate epel.sh
                activate hubot.sh
                activate logstash.sh
                activate mongodb.sh
                activate tox.sh
                shift
                ;;
            clean)
                exit 0
                ;;
            -h)
                print_usage
                shift
                ;;
            *)
                echo "error: unknown target '$1' ... aborting"
                print_usage
                shift
                ;;
        esac
    done
fi

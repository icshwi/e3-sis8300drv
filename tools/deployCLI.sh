#!/bin/sh
if [ "$UID" -ne 0 ] ; then
	echo "Deployment script must be run with root priviledges, existing"
	exit
fi

if [[ $# -ne 1 ]]; then
	echo "Usage: deployCLI.sh <EPICS_SRC>"
	echo "e.g deployCLI.sh $EPICS_SRC"
	exit
fi

EPICS_SRC=$1
installPath=/usr/bin
configPath=$EPICS_SRC/e3-sis8300drv/configure
sourcePath=$EPICS_SRC/e3-sis8300drv/m-kmod-sis8300/src/main/c

tools_version=$(grep -e E3_MODULE_VERSION "$configPath/CONFIG_MODULE")
tools_version=${tools_version#'E3_MODULE_VERSION:='}
echo "tools version = $tools_version"

# Deploy tools from local build directory to installation path

#Remove any existing configuration
for i in `ls $sourcePath | grep $tools_version`
do
    tool_name=${i%"_$tools_version"}
    if [ -L $instalPath/$tool_name ]
    then
        unlink "$installPath/$tool_name"
    fi
done

# Link the latest version of the sis830d0rv command line tools
for i in `ls $sourcePath | grep $tools_version`
do
    tool_name=${i%"_$tools_version"}
    if [ -L $installPath/$tool_name ]; then
        echo "$installPath/$tool_name"
        echo "$tool_name already exists in $installPath"
    else
        echo "1"
        echo "$installPath"
        echo "$tool_name"
	    eval "ln -s $sourcePath/$i $installPath/$tool_name"
    fi
done

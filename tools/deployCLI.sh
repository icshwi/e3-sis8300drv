#!/bin/sh
if [ "$UID" -ne 0 ] ; then
	echo "Deployment script must be run with root priviledges, existing"
	exit
fi

if [[ $# -ne 2 ]]; then
	echo "Usage: deployCLI.sh <EPICS_SRC> <SITELIBS PATH>"
	echo "e.g deployCLI.sh $EPICS_SRC $E3_SITELIBS_PATH"
	exit
fi

EPICS_SRC=$1
E3_SITELIBS_PATH=$2
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

# Make available library in LD_LIBRARY_PATH
a=$(grep -e "$E3_SITELIBS_PATH" /home/iocuser/.bashrc)
echo "len a = ${#a}"
if [ ${#a} -lt ${#E3_SITELIBS_PATH} ]; then
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$E3_SITELIBS_PATH/sis8300drv_$tools_version/linux_x86_64" >> ~/.bashrc
    source ~/.bashrc
else
    echo "LD_LIBRARY_PATH already includes E3_SITELIBS_PATH"
    echo "$a"
fi



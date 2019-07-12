#!/bin/sh
if [[ $# -ne 2 ]]; then
	echo "Usage: deployCLI.sh <EPICS_SRC> <SITELIBS PATH>"
	echo 'e.g deployCLI.sh $EPICS_SRC $E3_SITELIBS_PATH'
	exit
fi

EPICS_SRC=$1
E3_SITELIBS_PATH=$2
configPath=$EPICS_SRC/e3-sis8300drv/configure/CONFIG_MODULE

tools_version=$(grep -e E3_MODULE_VERSION "$configPath")
tools_version=${tools_version#'E3_MODULE_VERSION:='}
echo "tools version detected as $tools_version from $configPath"

# Make available library in LD_LIBRARY_PATH by appending to .bashrc is no entry already found
libPath="$E3_SITELIBS_PATH/sis8300drv_"$tools_version"_lib/linux-x86_64"
a=$(grep -e "$libPath" /home/iocuser/.bashrc)
echo "Exposing $libPath by inclusion in LD_LIBRARY_PATH"
if [ ${#a} -lt ${#E3_SITELIBS_PATH} ]; then
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$libPath" >> ~/.bashrc
else
    echo "LD_LIBRARY_PATH defintion already includes E3_SITELIBS_PATH"
    echo "$a"
fi
echo "New LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
source ~/.bashrc   

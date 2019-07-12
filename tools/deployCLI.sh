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

# Check locally built tools are available
temp=$(find $sourcePath -name "sis8300drv_reg_$tools_version")
if [ ${#temp} -eq 0 ]; then
    echo "Locally built tools not found for version $tools_version, exiting.."
    echo "Before running this deployment script again, build tools locally with the following:"
    echo "$ make tools"
    exit
fi

# Deploy tools from local build directory to installation path

#Remove any existing configuration
echo "Checking $installPath for existing sis8300 tools..."
for i in `ls $sourcePath | grep $tools_version`
do
    tool_name=${i%"_$tools_version"}
    if [ -L $installPath/$tool_name ];then
        echo "Removing existing $tool_name entry"
        eval "unlink $installPath/$tool_name"
    fi
done

# Link the latest version of the sis830d0rv command line tools
echo "Linking latest version of tools into $installPath..."
for i in `ls $sourcePath | grep $tools_version`
do
    tool_name=${i%"_$tools_version"}
    if [ -L $installPath/$tool_name ]; then
        echo "$tool_name already exists in $installPath"
    else
	echo "Linking version $tools_version of $tool_name"
	eval "ln -s $sourcePath/$i $installPath/$tool_name"
    fi
done

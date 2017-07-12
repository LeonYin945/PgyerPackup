#!/bin/bash

#任何命令执行出错既退出
set -e

if [ $# -ne 1 ]
then
  # echo "Usage: getmobileuuid the-mobileprovision-file-path"
  exit 1
fi

touch tempSecurity.plist
/usr/bin/security cms -D -i $1 >tempSecurity.plist 2> /dev/null
mobileprovision_uuid=`/usr/libexec/PlistBuddy -c "Print UUID" tempSecurity.plist` 
rm tempSecurity.plist
echo "${mobileprovision_uuid}"

#退出命令执行出错既退出模式
set +e

#!/bin/bash

#任何命令执行出错既退出
set -e
echo "packup shellConfigPath: ${1}"
echo "codePath:${2}"

configPlist_path=$1
codePath=$2
updateInfo=$3
echo "packup shellConfigPath: ${configPlist_path}"
echo "codePath:${codePath}"

#脚本路径
shell_path="$( cd "$( dirname "$0"  )" && pwd  )"
cd ${shell_path}

# 引入sh文件
source ./entranceExtension.sh

# 读取shellConfigPath中配置
codePathLenght=${#codePath}
echo codePathLenght:${codePathLenght}
if [[ ${codePathLenght} == "0"  ]]; then
    codePath=`/usr/libexec/PlistBuddy -c "print :codePath" $configPlist_path`
fi
projectRelativePath=`/usr/libexec/PlistBuddy -c "print :projectRelativePath" $configPlist_path`
projectPath="${codePath}/${projectRelativePath}"
# git config
gittag=`/usr/libexec/PlistBuddy -c "print :gittag" $configPlist_path`
gitbranch=`/usr/libexec/PlistBuddy -c "print :gitbranch" $configPlist_path`
# build config
projectName=`/usr/libexec/PlistBuddy -c "print :projectName" $configPlist_path`
projectSchemeName=`/usr/libexec/PlistBuddy -c "print :projectSchemeName" $configPlist_path`
outputName="${projectSchemeName}"
plistRelativePath=`/usr/libexec/PlistBuddy -c "print :plistRelativePath" $configPlist_path`
exportPath=`/usr/libexec/PlistBuddy -c "print :exportPath" $configPlist_path`
exportMethod=`/usr/libexec/PlistBuddy -c "print :exportMethod" $configPlist_path`
versionNumber=`/usr/libexec/PlistBuddy -c "print :versionNumber" $configPlist_path`
buildNumber=`/usr/libexec/PlistBuddy -c "print :buildNumber" $configPlist_path`
appleID=`/usr/libexec/PlistBuddy -c "print :buildConfig:appleID" $configPlist_path`
bundleIdentity=`/usr/libexec/PlistBuddy -c "print :buildConfig:bundleIdentity" $configPlist_path`
codesigningIdentity=`/usr/libexec/PlistBuddy -c "print :buildConfig:codesigningIdentity" $configPlist_path`
provisioningProfileName=`/usr/libexec/PlistBuddy -c "print :buildConfig:provisioningProfileName" $configPlist_path`
teamID=`/usr/libexec/PlistBuddy -c "print :buildConfig:teamID" $configPlist_path`
# upload config
upload=`/usr/libexec/PlistBuddy -c "print :upload" $configPlist_path`
apikey=`/usr/libexec/PlistBuddy -c "print :uploadConfig:apikey" $configPlist_path`
userkey=`/usr/libexec/PlistBuddy -c "print :uploadConfig:userkey" $configPlist_path`
password=`/usr/libexec/PlistBuddy -c "print :uploadConfig:password" $configPlist_path`

# 处理代码git版本  entranceExtension.sh
githandle "${codePath}" "${shell_path}" "${gittag}" "${gitbranch}"

# 打包
sh build.sh "${exportMethod}" "${versionNumber}" "${buildNumber}" "${projectPath}" "${exportPath}" "${shell_path}" "${teamID}" "${codesigningIdentity}" "${provisioningProfileName}" "${appleID}" "${bundleIdentity}" "${projectSchemeName}" "${plistRelativePath}" "${projectName}" "${outputName}"

# 上传 entranceExtension.sh
if [[ ${upload} == true ]]; then
    outputPath="${exportPath}/export/${buildNumber}/${outputName}.ipa"
    upload "${codePath}" "${shell_path}" "${userkey}" "${apikey}" "${password}" "${gittag}" "${outputPath}" "${updateInfo}"

fi

#退出命令执行出错既退出模式
set +e

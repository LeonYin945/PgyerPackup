#!/bin/bash

basicLanes=${1}
versionNumber=${2} # 1.0.0
buildNumber=${3} # 2000
projectPath=${4}
exportPath=${5}
shellPath=${6}
teamID=${7}
codesigningIdentity=${8}
provisioningProfileName=${9}
appleID=${10}
bundleIdentity=${11}
projectSchemeName=${12}
plistRelativePath=${13}
projectName=${14}
outputName=${15}

echo "sh getProfileUUID.sh ${shellPath}/Cert_Identifiers_Profiles/provisioning_profile/${provisioningProfileName}.mobileprovision"
profileUUID=`sh getProfileUUID.sh ${shellPath}/Cert_Identifiers_Profiles/provisioning_profile/${provisioningProfileName}.mobileprovision`

# 删除项目工程中的打包程序
rm -rf ${projectPath}fastlane
cp -r ${shellPath}/fastlane/ ${projectPath}fastlane

# 删除原输出路径
cd ${exportPath}
rm -rf export/
mkdir export/
mkdir export/${buildNumber}
mkdir export/${buildNumber}_dSYM

#到主目录下
cd $projectPath
pwd

echo "\033[32m 开始打包! \033[0m" 
echo "\033[32m ------------------------fastlane开始执行------------------------ \033[0m"
echo "\033[33m basicLanes:${basicLanes} \033[0m"
echo "\033[33m versionNumber:${versionNumber} \033[0m"
echo "\033[33m buildNumber:${buildNumber} \033[0m"
echo "\033[33m projectPath:${projectPath} \033[0m"
echo "\033[33m exportPath:${exportPath} \033[0m"
echo "\033[33m shellPath:${shellPath} \033[0m"
echo "\033[33m teamID:${teamID} \033[0m"
echo "\033[33m codesigningIdentity:${codesigningIdentity} \033[0m"
echo "\033[33m provisioningProfileName:${provisioningProfileName} \033[0m"
echo "\033[33m profileUUID:${profileUUID} \033[0m"
echo "\033[33m bundleIdentity:${bundleIdentity} \033[0m"
echo "\033[33m outputName:${outputName} \033[0m"
echo "\033[33m projectSchemeName:${projectSchemeName} \033[0m"
echo "\033[33m plistRelativePath:${plistRelativePath} \033[0m"
echo "\033[33m projectName:${projectName} \033[0m"
echo "\033[32m ---------------------------------------------------------------\033[0m"

fastlane $basicLanes version:"${versionNumber}" build:"${buildNumber}" exportPath:"${exportPath}" shellPath:"${shellPath}" teamID:"${teamID}" codesigningIdentity:"${codesigningIdentity}" provisioningProfileName:"${provisioningProfileName}" appleID:"${appleID}" bundleIdentity:"${bundleIdentity}" projectPath:"${projectPath}" outputName:"${outputName}" projectName:"${projectName}" projectSchemeName:"${projectSchemeName}" plistRelativePath:"${plistRelativePath}" profileUUID:"${profileUUID}"

rm -rf ${projectPath}fastlane

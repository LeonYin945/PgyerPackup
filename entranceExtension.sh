#!/bin/bash

#任何命令执行出错既退出
set -e 

function githandle() {
    codePath=$1
    shell_path=$2
    gittag=${3}
    gitbranch=${4}

    echo "\033[32m 开始处理git版本! \033[0m" 
    echo "\033[32m --------------------------------------------------------------- \033[0m"
    echo "\033[33m codePath:${codePath} \033[0m"
    echo "\033[33m shellPath:${shell_path} \033[0m"
    echo "\033[33m gittag:${gittag} \033[0m"
    echo "\033[33m gitbranch:${gitbranch} \033[0m"
    echo
    
    cd ${codePath}
    gittag=${gittag// /}
    gitbranch=${gitbranch// /}
    local gittagLenght=${#gittag}
    if [[ ${gittagLenght} != "0"  ]]; then
        git fetch --tags
        git checkout .
        git checkout ${gittag}
        echo "\033[32m 已设置tag，切换到gittag:${gittag} \033[0m"
    else
        
        local gitbranchLenght=${#gitbranch}
        if [[ ${gitbranchLenght} != "0"  ]]; then
            git checkout .
            git checkout ${gitbranch}
            git pull
            echo "\033[32m 打包时未设置tag，切换到gitbranch:${gitbranch} git pull \033[0m"
        else
            echo "\033[32m 打包时未设置tag和gitbranch 不处理git版本 \033[0m"
        fi
    fi
    cd ${shell_path}
    echo "\033[32m ---------------------------------------------------------------\033[0m"
}

function packaging() {
    echo packaging
}

function upload() {
    codePath=$1
    shell_path=$2
    userkey=$3
    apikey=$4
    PASSWORD=$5
    gittag=$6
    outputPath=$7

    cd ${codePath}
    local installType="1"
    local passwordLenght=${#PASSWORD}
    if [[ ${passwordLenght} != "0"  ]]; then
        installType="2"
    fi

    MSG="上传版本：gittag：${gittag}"
    local gittagLenght=${#gittag}
    if [[ ${gittagLenght} == "0"  ]]; then
        local MSG=`git log -1`
    fi
    MSG=$(echo ${MSG} | sed 's/\r/ /g') 
    MSG=$(echo ${MSG} | sed 's/\n/ /g')
    
    echo "\033[32m 开始打包! \033[0m" 
    local retryCount=3
    for ((i=1;i<=retryCount;i++)) do
        echo "\033[32m ----------------upload开始执行${i}/${retryCount}---------------- \033[0m"
        echo "\033[33m codePath:${codePath} \033[0m"
        echo "\033[33m shellPath:${shell_path} \033[0m"
        echo "\033[33m outputPath:${outputPath} \033[0m"
        echo "\033[33m gittag:${gittag} \033[0m"
        echo "\033[33m userkey:${userkey} \033[0m"
        echo "\033[33m apikey:${apikey} \033[0m"
        echo "\033[33m PASSWORD:${PASSWORD} \033[0m"
        echo "\033[33m MSG:${MSG} \033[0m"

        local res=`curl -F "file=@${outputPath}" -F "uKey=${userkey}" -F "_api_key=${apikey}" -F "updateDescription=${MSG}" -F "installType=${installType}" -F "password=${PASSWORD}" https://qiniu-storage.pgyer.com/apiv1/app/upload`
        local code=`echo ${res}| jq .code`
        # echo res:${res}
        # echo code:${code}
        if [[ ${code} == "0" ]]; then
            echo
            echo "\033[32m ----------------------upload成功---------------------------\033[0m"
            local appName=$(echo `echo ${res}| jq .data.appName` | sed 's/\"//g')
            local appVersion=$(echo `echo ${res}| jq .data.appVersion` | sed 's/\"//g')
            local appVersionNo=$(echo `echo ${res}| jq .data.appVersionNo` | sed 's/\"//g')
            local appBuildVersion=$(echo `echo ${res}| jq .data.appBuildVersion` | sed 's/\"//g')
            local appIdentifier=$(echo `echo ${res}| jq .data.appIdentifier` | sed 's/\"//g')
            local appShortcutUrl=$(echo `echo ${res}| jq .data.appShortcutUrl` | sed 's/\"//g')
            local downloadUrl="https://www.pgyer.com/${appShortcutUrl}"
            local appKey=$(echo `echo ${res}| jq .data.appKey` | sed 's/\"//g')
            local cruBuildUrl="https://www.pgyer.com/${appKey}"
            local appFileSize=$(echo `echo ${res}| jq .data.appFileSize` | sed 's/\"//g')
            local appUpdated=$(echo `echo ${res}| jq .data.appUpdated` | sed 's/\"//g')
            local appQRCodeURL=$(echo `echo ${res}| jq .data.appQRCodeURL` | sed 's/\"//g')
            local appUpdateDescription=$(echo `echo ${res}| jq .data.appUpdateDescription` | sed 's/\"//g')

            echo "\033[33m APP名称:${appName} \033[0m"
            echo "\033[33m app版本:${appVersion} \033[0m"
            echo "\033[33m app版本号:${appVersionNo} \033[0m"
            echo "\033[33m 全部版本地址:${downloadUrl} \033[0m"
            echo "\033[33m 当前版本地址:${cruBuildUrl} \033[0m"
            echo "\033[33m 密码:${PASSWORD} \033[0m"
            echo "\033[33m 蒲公英build号:${appBuildVersion} \033[0m"
            echo "\033[33m 说明:\r\n${appUpdateDescription} \033[0m"
            `echo "APP名称:${appName}\r\napp版本:${appVersion}\r\napp版本号:${appVersionNo}\r\n全部版本地址:${downloadUrl}\r\n当前版本地址:${cruBuildUrl}\r\n密码:${PASSWORD}\r\n蒲公英build号:${appBuildVersion}\r\n说明:\r\n${appUpdateDescription} " | pbcopy`
            echo "\033[32m ---------------------蒲公英相关信息已复制--------------------\033[0m"
            break
        else
            echo
            if [[ ${i} == ${retryCount} ]]; then 
            echo "\033[31m ----------------------upload${retryCount}次失败，请确认网络环境畅通后重试---------------------------\033[0m"
            fi
        fi
    done
    cd ${shell_path}
}

#退出命令执行出错既退出模式
set +e


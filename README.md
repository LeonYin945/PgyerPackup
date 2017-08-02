# PgyerPackup
shell脚本+fastlane打包+蒲公英上传
## 一、目录文件说明

* build.sh 调用 fastlane 的打包脚本
* entrance.sh：传入ShellConfig.plist的地址即可开始任务
* Cert_Identifiers_Profiles 此目录下可预置profile，如果对应的profile存在即不会从网络下载
* entranceExtension.sh 其中包含git版本处理，上传
* fastlane 的打包脚本，需要安装 fastlane 环境。
* getProfileUUID.sh 获取profile的uuid
* start 此目录下存放start与ShellConfig.plist 配置文件，plist配置好后，点击start文件即可开始任务。此文件夹可复制多份存放在任意目录下，配置相应的shellConfig即可实现，单脚本，多配置打包。

## 二、ShellConfig.plist  配置说明

* exportMethod ：打包类型区分
* TestEnterprise(企业包)。
* entrancePath ：脚本路径
* projectName：工程名称
* projectSchemeName：需要打包的
* SchemeName
* codePath : 工程路径，工程的顶级目录
* projectRelativePath：此目录底下应该为. xcodeproj的路径   且是相对于codePath的路径
* plistRelativePath：此为相对路径，相对于projectRelativePath的info.plist的路径
* exportPath ：输出包的路径，会输出 ipa包和 符号表。每次打包前会清空此目录请注意！！！
* versionNumber:  在执行 build.sh 会替换 info.plist  内容(Version)。
* buildNumber  :    在执行 build.sh 会替换 info.plist  内容(Build)。

* gittag，gitbranch：如果设置过gittag，则直接checkout对应tag打包，若只设置了gitbranch，则checkout对应branch，pull后打包，若均未设置，则使用本地代码打包

* upload：YES OR NO

* uploadConfig：必须配置 apikey，userkey从蒲公英获取，password为下载时的密码

* buildConfig：必须配置，一个也不能少

## 三、环境 配置说明


* 第一步：更新ruby  
安装rvm  
$ curl -L get.rvm.io | bash -s stable
$ source ~/.profile
等待终端加载完毕，后输入：
$ rvm -v
* 第二步：安装ruby  
列出ruby可安装的版本信息
$ rvm list known
* 安装一个ruby版本 
$ rvm install 2.4
如果想设置为默认版本，可以用这条命令来完成
$ rvm use 2.4.0
查看已安装的ruby
$ rvm list

* gem 换源  
https://gems.ruby-china.org/
连上vpn更新gem
$ sudo gem update —system
$ gem sources --add https://gems.ruby-china.org --remove https://rubygems.org/
$ gem sources -l
$ gem sources -u #更新

* 安装cocoapod  
$ sudo gem install cocoapods --version 1.1.1

* 安装fastlane  
$ sudo gem install -n /usr/local/bin fastlane

* 安装JQ  
$ brew install jq

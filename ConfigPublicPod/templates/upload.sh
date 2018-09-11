#!/bin/bash

Cyan='\033[0;36m'
Default='\033[0;m'

versionNum=""
privatePodsName=""
projectName=""
confirmed="n"


getVersionNum(){
    read -p "Enter VersionNum:" versionNum

    if test -z "$versionNum";then
        getVersionNum
    fi
}

getPrivatePodsName(){
    read -p "Enter privatePodsName:" privatePodsName

    if test -z "$privatePodsName";then
        getPrivatePodsName
    fi
}

getProjectName(){
    read -p "Enter projectName:" projectName

    if test -z "$projectName";then
        getProjectName
    fi
}

getInfomation(){
    getProjectName
    getVersionNum
    getPrivatePodsName


    echo -e "============================================"
    echo -e "projectName      : ${Cyan}${projectName}${Default}"
    echo -e "versionNum       : ${Cyan}${versionNum}${Default}"
    echo -e "privatePodsName  : ${Cyan}${privatePodsName}${Default}"
    echo -e "============================================"
}

echo -e "\n"
while [ "$confirmed" != "y" -a "$confirmed" != "Y" ]
do
    if [ "$confirmed" == "n" -o "$confirmed" == "N" ]; then
       getInfomation
    fi
    read -p "confirm? (y/n):" confirmed
done



git add .
git commit -m ${versionNum}
git tag ${versionNum}
git push origin master --tags
pod spec lint ${projectName}.podspec --use-libraries
pod repo push ${privatePodsName} ${projectName}.podspec --verbose --allow-warnings --use-libraries

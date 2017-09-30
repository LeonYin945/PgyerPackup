#!/bin/bash

projPath=$1
pbxprojPath="project.pbxproj"

cd ${projPath}

automatics=$(grep 'Automatic' ${pbxprojPath})
replaceNum=$(grep 'Automatic' project.pbxproj|wc -l)

for (( idx = 1; idx <= replaceNum; idx++ )); do
  automaticStr=$(echo $automatics | awk -F';' '{print $idx}' idx=$idx)
  automaticStr=$(echo $automaticStr | awk '{sub(/^ */,"");sub(/ *$/,"")}1')
  manualStr=$(echo ${automaticStr} | sed 's/Automatic/Manual/g')
  echo automaticStr:${automaticStr} manualStr:${manualStr}
  sed -i "" "s/${automaticStr}/${manualStr}/g" ${pbxprojPath}
  unset replaceStr
  unset manualStr
done

replaceNum=$(grep 'Automatic' project.pbxproj|wc -l)
if [[ ! ${replaceNum} -eq 0  ]]; then
  echo "error replaceNum:${replaceNum}"
  exit 1
fi

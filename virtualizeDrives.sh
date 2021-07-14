#!/bin/bash
rawData=$(lsblk -nr -o NAME,MOUNTPOINT,PKNAME);
while read -r -a line; do
    if [ "${line[1]}" == "/" ]; then
        bootDrive="${line[2]}";
    fi
done <<< "${rawData}";
rawData=$(lsblk -dnr -o NAME,SIZE,MODEL);
selectionString="";
while read -r -a line; do
    if [ "${line[0]}" != "${bootDrive}" ]; then
        selectionString="${selectionString} ${line[0]} \"$(echo ${line[2]} | sed 's/\\x20/ /g') (${line[1]})\" off"
    fi
done <<< "${rawData}";
command="kdialog --geometry 500x500 --checklist \"Please Select drives\" ${selectionString};";
drives=$(eval "${command}");
declare -a array=($drives)
for drive in "${array[@]}"; do
    echo "${drive}";
done

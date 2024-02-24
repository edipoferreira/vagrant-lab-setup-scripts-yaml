#!/usr/bin/env bash

FILESYSTEM="/"
# Get LV from filesystem
LV=$(df -h -l --output=source $FILESYSTEM|sed 1d)
echo "Filesystem: $FILESYSTEM , LV: $LV"
# Get VG from LV
VG=$(lvs $LV -o vg_name --noheadings|tr -d ' ')
echo "VG: $VG"
for pv in $(pvs --separator ';' --noheadings|tr -d ' ')
do
  PV=$(echo $pv|cut -d ';' -f 1)
  VG_PV=$(echo $pv|cut -d ';' -f 2)
  if [ "$VG" == "$VG_PV" ]
  then
    echo "$VG e $VG_PV iguais"

    DISK=$(echo $PV|sed -r 's/(.*)(p?[0-9]+)$/\1/')
    echo "DISK: $DISK"
    PART_NUM=$(echo $PV|sed -r 's/(.*)(p?[0-9]+)$/\2/')
    echo "DISK: $PART_NUM"

    echo "FIX GPT Disk Table"
    sgdisk $DISK -e
    parted -s $DISK resizepart $PART_NUM 100%

    echo "Resize PV: $PV"
    pvresize $PV
    
    echo "Resize LV and Filesystem: "
    lvextend -l +100%FREE -r $LV

    df -h $FILESYSTEM

    
  fi
done

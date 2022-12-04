#!/system/bin/sh

echo 1 > /sys/fs/selinux/log

is_relabel=`cat /asdf/relabel.txt`

echo "relabel:"$is_relabel > /proc/asusevtlog


echo 1 > /sys/fs/selinux/log
count=1


while [ -x  "$(command -v /system/bin/restorecon)" ] && [ "$count" != 5 ]
do
	echo "restorecon commands not found" > /proc/asusevtlog
	count=$(($count+1))
	sleep 1
done




echo 1 > /sys/fs/selinux/log
/system/bin/restorecon -FR /data/misc/keystore/user_0
/system/bin/restorecon -FR /data/data/com.google.android.gms/
/system/bin/restorecon -FR /data/data/com.google.android.gm/
/system/bin/restorecon -FR /data/data/com.android.vending/
/system/bin/restorecon -FR /data/app  > /proc/asusevtlog 2> /proc/asusevtlog
/system/bin/restorecon -FR /data/user/2357
/system/bin/restorecon -FR /data/user/0
/system/bin/restorecon -FR /data/data/jp.naver.line.android/databases
/system/bin/restorecon -FR /data/data/com.facebook.katana/
/system/bin/restorecon -FR /data/data/com.instagram.android/
restorecon -FR /data/data/jp.naver.line.android/databases

function scanFolder(){
#	if [ -d "$1" ];  then
		for i in "$1"/* ;
		do
			echo 1 > /sys/fs/selinux/log
			
			if [ -d "$i" ]; then
				datalabel=`ls -aZ $i | grep "unlabel"` 2>/dev/null
				#datalabel=`ls -Z $i | grep "app_data_file"` 2>/dev/null
				if [ "$datalabel" != "" ]; then
					s=$i/`echo  $datalabel | cut -d " " -f 2`
					echo selinux relabel :$s > /proc/asusevtlog
					/system/bin/restorecon -FR $s 2>/proc/asusevtlog >/proc/asusevtlog
				fi
				scanFolder "$i"
			else
				datalabel=`ls -aZ $i | grep "unlabel"` 2>/dev/null
				#datalabel=`ls -Z $i | grep "app_data_file"` 2>/dev/null
				if [ "$datalabel" != "" ]; then
					s=$i/`echo  $datalabel | cut -d " " -f 2`
					echo selinux relabel :$s > /proc/asusevtlog
					/system/bin/restorecon -FR $s 2>/proc/asusevtlog >/proc/asusevtlog
				fi
			fi
		done
	
#	fi
		

}

function scanHiddenFolder(){
#	if [ -d "$1" ];  then
		for i in "$1"/.* ;
		do
			
			echo 1 > /sys/fs/selinux/log
			if [ -d "$i" ]; then
				datalabel=`ls -aZ $i | grep "unlabel"` 2>/dev/null
				#datalabel=`ls -Z $i | grep "app_data_file"` 2>/dev/null
				if [ "$datalabel" != "" ]; then
					s=$i/`echo  $datalabel | cut -d " " -f 2`
					echo selinux relabel :$s > /proc/asusevtlog
					/system/bin/restorecon -FR $s 2>/proc/asusevtlog >/proc/asusevtlog
				fi
				scanFolder "$i"
			else
				datalabel=`ls -aZ $i | grep "unlabel"` 2>/dev/null
				#datalabel=`ls -Z $i | grep "app_data_file"` 2>/dev/null
				if [ "$datalabel" != "" ]; then
					s=$i/`echo  $datalabel | cut -d " " -f 2`
					echo selinux relabel :$s > /proc/asusevtlog
					/system/bin/restorecon -FR $s 2>/proc/asusevtlog >/proc/asusevtlog
				fi
			fi
		done
	
#	fi
		

}

scanFolder /data/data/com.facebook.katana
scanFolder /data/data/com.facebook.orca
scanFolder /data/data/com.instagram.android
scanFolder /data/data/com.google.android.googlequicksearchbox
scanFolder /data/data/com.google.android.gm
scanFolder /data/user/2357/jp.naver.line.android
scanFolder /data/user/2357/com.facebook.katana

/system/bin/restorecon -FR /data/user/2357/jp.naver.line.android/shared_prefs
/system/bin/restorecon -FR /data/user/2357/jp.naver.line.android/cache/image_manager_disk_cache
/system/bin/restorecon -FR /data/user/2357/com.facebook.katana/cache/compactdisk/image/1/sessionless/storage
scanFolder /data/user/2357/com.facebook.katana/cache/compactdisk/image/1/sessionless/storage
scanFolder /data/user/2357/jp.naver.line.android/shared_prefs
scanFolder /data/user/2357/jp.naver.line.android/cache/image_manager_disk_cache

if [ "$is_relabel" == "" ] || [ "$is_relabel" == "0" ] || [ "$is_relabel" == "3" ] || [ "$is_relabel" == "4" ];  then
	echo "relabel stage 3 "> /proc/asusevtlog
	ls -alRZ /data > /asdf/dataSelinux.txt
	scanFolder /data/system
	scanHiddenFolder /data/system
	echo 3 > /asdf/relabel.txt 
	scanFolder /data/data
	scanHiddenFolder /data/data
	echo 4 > /asdf/relabel.txt
	scanFolder /data/media
	scanFolder /data/user/0
	scanFolder /data/user/2357
	scanHiddenFolder /data/media
	scanHiddenFolder /data/user/0
	scanHiddenFolder /data/user/2357
	echo 5 > /asdf/relabel.txt
fi


if [ "$is_relabel" == "3" ]; then
	echo "relabel stage 4 "> /proc/asusevtlog
	scanFolder /data/data
	scanHiddenFolder /data/data
	echo 4 > /asdf/relabel.txt
	scanFolder /data/media
	scanFolder /data/user/0
	scanFolder /data/user/2357
	scanHiddenFolder /data/media
	scanHiddenFolder /data/user/2357
	scanHiddenFolder /data/user/0
	echo 5 > /asdf/relabel.txt
fi

if [ "$is_relabel" == "4" ]; then
	echo "relabel stage 5 "> /proc/asusevtlog
	scanFolder /data/media
	scanFolder /data/user/0
	scanFolder /data/user/2357
	scanHiddenFolder /data/user/0
	scanHiddenFolder /data/media
	scanHiddenFolder /data/user/2357
	echo 5 > /asdf/relabel.txt
fi

echo "End relabel "> /proc/asusevtlog

if [ "$is_relabel" != "5" ]; then
	sleep 5
	echo 0 > /sys/fs/selinux/log
fi






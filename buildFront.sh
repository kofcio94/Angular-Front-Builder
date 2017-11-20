#!/bin/bash

currentPath=$(pwd)

args=("$@") 
ELEMENTS=${#args[@]} 

for (( i=0;i<$ELEMENTS;i++)); do 
if [ ${args[${i}]} == '' ] || [ ${args[${i}]} == "-h" ] || [ ${args[${i}]} == "-help" ] || [ ${args[${i}]} == "--help" ] ;
	then
		echo 'Builds Angular front for Android repo.
Default path for repo is /home/user/Repo/Android/supermemo-com-android.

Arguments:
1: --bin or --build 
2: --branch dafault is lastly used branch
3: --pull does not pull again if used
4: --path_front absolute front path
5: --path_android absolute destination path
6: --commit get front with commit id' 
		exit
	fi
done

for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--bin' ] ; then
		echo 'Generating BIN front'
		break
	elif [ ${args[${i}]} == '--build' ] ; then
		echo 'Generating BUILD front'
		break
	else 
		echo 'Generating BUILD front'
		break
	fi
done

#setting path to front repo
subPath='/supermemo-core-gui'
frontPath='/home/'$USER'/Repo/frontend'
for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--path_front' ] ; then
		frontPath=${args[${i+1}]}
		break
	fi
done
finalPathFront=$frontPath$subPath

#setting path to androi repo
subPath='/supermemo-com-android/app/src/main'
androidPath='/home/'$USER'Repo/android'
for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--path_android' ] ; then
		androidPath=${args[${i+1}]}
		break
	fi
done
finalPathAndroid=$androidPath$subPath

cd "$finalPathFront"

for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--branch' ] ; then 
		branch=${args[${i+1}]}
		git checkout "$branch"
		break
	fi
done

for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--commit' ] ; then
		branch=${args[${i+1}]}
		git checkout "$branch"
		break
	fi
done

for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--pull' ] ; then
		git pull origin "$branch"	
		break
	fi
done

grunt

rm -rf $finalPathAndroid'/assets'

bin='false'
for (( i=0;i<$ELEMENTS;i++)); do 
	if [ ${args[${i}]} == '--bin' ] ; then
		mkdir $finalPathAndroid'/assets'
		mkdir $finalPathAndroid'/assets/www'
		mkdir $finalPathAndroid'/assets/www/bin'

		cp $finalPathFront'/bin/gui.zip' $finalPathAndroid'/www/bin'

		cd $finalPathAndroid'/www/bin'
	
		unzip $finalPathAndroid'/assets/www/bin/gui.zip'
				
		rm -rf gui.zip
		bin='true'
		break
	fi
done

if [ bin == 'false' ] ; then
	mkdir $finalPathAndroid'/assets'
	mkdir $finalPathAndroid'/assets/www'
	cp -rf $finalPathFront'/build' $finalPathAndroid'/assets/www'
	mv  $finalPathAndroid'/assets/www/build'  $finalPathAndroid'/assets/www/bin'
fi

cd "$currentPath"








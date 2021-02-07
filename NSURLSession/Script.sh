#!/bin/bash
filePath=$1
unfileName=$2
fileName="RD_FS.app"
desktop="/Users/patrick/Desktop/"

echo "cd ..."
cd $filePath

echo "unzip file ..."
unzip $unfileName

echo "rm -rf file ..."
rm -rf $desktop$fileName

sleep 1
echo "mv app to desktop ..."
#mv $filePath$fileName desktop
mv $fileName $desktop

echo "rm -rf .zip file"
rm -rf $unfileName

echo "cd desktop"
cd $desktop

echo "open app"
open $fileName

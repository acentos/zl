#!/bin/bash

CPU_LIMIT=60

rpm -q ffmpeg > /dev/null
if [ $? -ne 0 ];then
   echo "[!] package is ffmpeg is not exists."
   exit 0
fi

rpm -q cpulimit > /dev/null
if [ $? -ne 0 ];then
   echo "[!] package is cpulimit is not exists."
   exit 0
fi

function check_dir_mp4() {
  if [ ! -d mp4 ];then
    mkdir mp4;
  fi
}

MP4L=`ls | grep '.mp4' | grep -v $(basename '$0') | wc -l`

echo "[i] total mp4 files $((MP4L  - 1))."
if [ $? -ne 0 ];then
  echo "[i] no files *.mp4....exit";
  exit 0
fi

if [[ $((MP4L  - 1)) == 0 ]];then
  echo "[i] no files *.mp4....exit";
  exit 0
fi


echo "==================================";
date
echo "==================================";
echo -e "[i] CPU Limit = ${CPU_LIMIT}%"
check_dir_mp4

count=0;
for f in *.mp4; do
  count=$(expr $count + 1);
  echo -e "${count})\t ${f}";
  name=`echo "$f" | sed -e "s/.mp4$//g"`;
  cpulimit -l ${CPU_LIMIT} ffmpeg -i "$f" -vn -ar 44100 -ac 2 -ab 192k -f mp3 "$name.mp3" -loglevel error ;
  sleep 4;  
done
echo "==================================";
uptime;
echo "==================================";

echo "[i] move *.mp4 to dir: mp4";
check_dir_mp4
mv *.mp4 mp4/

echo "==================================";
total=`ls | grep mp3 | grep -v 'mp4_to_mp3'| wc -l`

echo -e "[+] list of mp3 files - total: (${total}):"
ls | grep "mp3"
date


#!/bin/bash
#usage: webp2gif input.webp output.gif

hasCommandByType(){
    if type $1 2>/dev/null; 
    then
        return 1
    else
        return 0
    fi
}

cur=""
hasCommandByType webpinfo
returnValue=$?
cur+=$returnValue
hasCommandByType dwebp
returnValue=$?
cur+=$returnValue
hasCommandByType dwebp
returnValue=$?
cur+=$returnValue
hasCommandByType webpmux
returnValue=$?
cur+=$returnValue
if [[ $cur != "1111" ]]; then
	echo "miss depency"
	exit 0
fi
#########start#########
cur_dir=$(pwd) # 获取当前目录
temp_dir=$(mktemp -d) # 整一个临时目录
cd $temp_dir	# 进入临时文件夹
webpfile=$1	# 获取第一个参数，也就是你传递进去的webp文件
if [[ ! -f $webpfile ]];then
    webpfile=$cur_dir/$webpfile # 拼接webp文件的全路径（首先检查了文件是否存在,如果存在就忽略了。如果不存在，就拼接当前目录路径）
fi
frames_num=$(webpinfo $webpfile|grep Format|wc -l) # 这个比较有意思，webpinfo会现实每一帧，然后他数了里面有多少个 Format 并且计数了
for i in $(seq 0 $frames_num);do
    webpmux -get frame $i $webpfile -o "$i.webp" # 循环获取这一帧,理解成指针指到了某一帧
    dwebp "$i.webp" -o "$i.png"			 # 用dwebp把这一帧转成了png
done;
for i in {1..9}
do
   if [[ -f "$i.png" ]];then
       mv "$i.png" "0$i.png" # 这里是为了将前面1-9的前面补位01、02、03
   fi
done
convert -delay 0 -loop 0 *.png animation.gif # 转换成gif
mv $temp_dir/animation.gif $cur_dir/$2	     # 转换成目标文件名，这里不够智能，这货竟然还要丢在原本的文件夹下	
rm -rf $temp_dir

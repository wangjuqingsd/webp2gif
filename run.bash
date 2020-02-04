#!/bin/bash
#usage: test input.webp output.gif
# 
## 判断命令是否存在
hasCommandByType(){
    if command -v $1 >/dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}
#### start ####
# 首先判断是否有webpinfo webpmux dwebp convert 这三个命令
# 三个缺一不可，少了不让他执行
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
# 判断 $1 是否为一个文件，如果否，尝试将当前目录拼接到$1前面，看他是否是个文件，如果还不是，终止
working_dir=$(pwd)
# 创建临时目录，mktmp
tmp_dir=$(mktemp -d) 
cd $tmp_dir
webpfile=$1
if [[ ! -f $webpfile ]]; then	#TODO 这里需要查一查API了，在当前目录下webpfile这个变量不需要加$，如果加了访问不到……所以姑且先跳转过去罢
	webpfile=$working_dir/$webpfile
fi
# 获取帧数
frame_num=$(webpinfo $webpfile|grep Format|wc -l)
frame_num_str=$frame_num""
frame_num_length=${#frame_num_str}
# 循环指针，拆分成一个个的png文件放到临时文件夹下面
echo "start to split frames"
ll_magic=$((10**$frame_num_length))
# 补位数

for (( i = 0; i < frame_num; i++ )); do
	webpmux -get frame $i $webpfile -o "$i.webp" 2>/dev/null
	out=$(($ll_magic+$(($i))))
	out=${out:1}
	dwebp "$i.webp" -o "$out.png" 2>/dev/null
	rm -rf "$i.webp"
done
# convert这些png变成gif
echo "start to implode png to gif "
convert -delay 0 -loop 0 *.png final.gif # 临时gif
mv $tmp_dir/final.gif $working_dir/$2
rm -rf $tmp_dir
echo "oops,we done here"
exit 1

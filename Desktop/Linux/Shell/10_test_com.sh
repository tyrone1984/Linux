num1=100
num2=100
if test $[num1] -eq $[num2]; then
	echo "两个数相等"
else
	echo "两个数不相等"
fi

# 代码中的 [] 执行基本的算数运算
a=5
b=6
result=$[a+b]
echo "result为: $result"


#文件测试
# 参数	说明
# -e 文件名	如果文件存在则为真
# -r 文件名	如果文件存在且可读则为真
# -w 文件名	如果文件存在且可写则为真
# -x 文件名	如果文件存在且可执行则为真
# -s 文件名	如果文件存在且至少有一个字符则为真
# -d 文件名	如果文件存在且为目录则为真
# -f 文件名	如果文件存在且为普通文件则为真
# -c 文件名	如果文件存在且为字符型特殊文件则为真
# -b 文件名	如果文件存在且为块特殊文件则为真
cd /bin
if test -e ./bash; then
	echo "文件已存在"
else 
	echo "文件不存在"
fi

# grep --color "sh"

# grep -c ".sh"

if [ $(ps -ef | grep -c "ch") -gt 1 ]; then
	echo "true"
else
	echo "false"
fi
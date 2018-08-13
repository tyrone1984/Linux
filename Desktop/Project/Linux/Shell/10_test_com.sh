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

# while
#
int=1
while (( int<=5 )) ; do
	echo $int
	let "int++"
done

int=1
while [[ $int -le 5 ]]; do
	echo $int
	let int++	# let 命令，它用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量
done

# echo "按下 <CTRL+D 退出>"
# echo "输入你最喜欢的网站名: "
# while read FILM; do
# 	echo "输入的网站是: $FILM" 
# 	break
# done

## until 循环
## until 循环执行一系列命令直至条件为 true 时停止。

a=0
until [[ ! $a -lt 10 ]]; do
	echo $a
	#a=`expr $a + 1`
	let a++
done

## case 
read -p "请输入1到4之间的数字:" aNum
case $aNum in
	1 ) echo "你选择了1"
		;;
	2 ) echo "你选择了2"
		;;
	3 ) echo "你选择了3"
		;;
	4 ) echo "你选择了4"
		;;
esac

# 无限循环
:<<! 
while true
do
    command
done

while :
do
    command
done
!

while : 
do
	echo -n "输入1到5之间的数字:"
	read aNum
	case  $aNum in
		1|2|3|4|5 ) echo "你输入的数字为$aNum!"
			;;
		* ) echo "你输入的数字不是1到5之间!游戏结束"
		break
		;;
	esac
done

# 通常情况下 shell 变量调用需要加 $,但是 for 的 (()) 中不需要,下面来看一个例子：
for (( i = 0; i < 10; i++ )); do
	echo "这是第 $i 次调用了" # $i左右要有空格
done


if [ "${-#*i}" != "$-" ];



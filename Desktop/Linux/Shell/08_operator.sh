#### 关系运算符
:<<!
-gt是大于的意思。

-eq是等于的意思。

-ne是不等于的意思。

-ge是大于等于的意思。

-lt是小于的意思。

-le是小于等于的意思。
!

#### 布尔运算符 !(非) -o(或) -a(与: 两个表达式都为 true 才返回 true。)
# 其优先级为："!"最高，"-a"次之，"-o"最低
a=10
b=20
if [[ $a != $b ]]; then			#	表达式和运算符之间要有空格
	echo "a 不等于 b : $a != $b"
else
	echo "a 等于 b : $a == $b"
fi

if [ $a -lt 100 -a $b -gt 15 ]; then
	echo "$a 小于100 且 $b 大于15 ： 返回true"
else
	echo "$a 小于100 且 $b 大于15 ： 返回false"
fi

if [ $a -lt 100 -o $b -gt 15 ]; then
	echo "$a 小于100 或 $b 大于15 ： 返回true"
else
	echo "$a 小于100 或 $b 大于15 ： 返回false"
fi

#### 逻辑运算符
if [[ $a -lt 100 && $b -gt 100 ]]; then
	echo "$a 小于100 且 $b 大于100 ： 返回true"
else
	echo "$a 小于100 且 $b 大于100 ： 返回false"
fi

if [[ $a -lt 100 || $b -gt 100 ]]; then
	echo "$a 小于100 或 $b 大于100 ： 返回true"
else
	echo "$a 小于100 或 $b 大于100 ： 返回false"
fi

#### 字符串运算符
# >、<、==、!= 也可以进行字符串比较。
:<<!
if [ str1 = str2 ]		当两个串有相同内容、长度时为真 
if [ str1 != str2 ]		当串str1和str2不等时为真 
if [ -n str1 ]			当串的长度大于0时为真(串非空) 
if [ -z str1 ]			当串的长度为0时为真(空串) 
if [ str1 ]				当串str1为非空时为真
shell 中利用 -n 来判定字符串非空。
!

a="abc"
b="efg"
if [ $a = $b ]; then	# 进行字符串比较时，== 可以使用 = 替代。
	echo "$a = $b : a 等于 b"
else
	echo "$a = $b : a 不等于 b"
fi

if [ $a != $b ]; then
	echo "$a != $b : a 不等于 b"
else
	echo "$a != $b : a 等于 b"
fi

# > 和 < 进行字符串比较时，需要使用[[ string1 OP string2 ]] 或者 [ string1 \OP string2 ]。
# 也就是使用 [] 时，> 和 < 需要使用反斜线转义。
if [ $a \> $b ]; then
	echo "$a > $b : a 大于 b"
else
	echo "$a > $b : a 小于 b"
fi

if [[ $a > $b ]]; then
	echo "$a > $b : a 大于 b"
else
	echo "$a > $b : a 小于 b"
fi

if [ -z $a ]; then
	echo "-z $a : 字符串长度为 0为真"
else
	echo "-z $a : 字符串长度为 0 为假"
fi

if [ -n $a ]; then
	echo "-n $a : 字符串长度大于 0为真"
else
	echo "-n $a : 字符串长度大于 0为假"
fi

if [ $a ]; then
	echo "$a : 字符串不为空 :真"
else
	echo "$a : 字符串不为空 :假"
fi

# Shell 相加目前发现有 3 种写法：

# a=10
# b=20
# c=`expr ${a} + ${b}`
# echo "$c"

# c=$[ `expr 10 + 20` ]
# echo "$c"

# c=$[ 10 + 20 ]
# echo "$c"


#文件表达式
:<<!
if [ -f  file ]    如果文件存在
if [ -d ...   ]    如果目录存在
if [ -s file  ]    如果文件存在且非空 
if [ -r file  ]    如果文件存在且可读
if [ -w file  ]    如果文件存在且可写
if [ -x file  ]    如果文件存在且可执行 
!  


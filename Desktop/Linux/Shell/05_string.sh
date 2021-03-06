# Linux 的字符串截取很有用。有八种方法。

:<<!
	注：（左边的第一个字符是用 0 表示，右边的第一个字符用 0-1 表示）
!

# 1. # 号截取，删除左边字符，保留右边字符。
:<<!
	其中 var 是变量名，# 号是运算符，*// 表示从左边开始删除第一个 // 号及左边的所有字符 即删除 http://
!
var="https://www.baidu.com/123.html"
echo ${var#*//}

# 2. ## 号截取，删除左边字符，保留右边字符。
:<<!
	##*/ 表示从左边开始删除最后（最右边）一个 / 号及左边的所有字符
!
echo ${var##*/}

# 3. %号截取，删除右边字符，保留左边字符
:<<!
	%/* 表示从右边开始，删除第一个 / 号及右边的字符
!
echo ${var%/*}

# 4. %% 号截取，删除右边字符，保留左边字符
:<<!
	%%/* 表示从右边开始，删除最后（最左边）一个 / 号及右边的字符
!
echo ${var%%/*}

# 5. 从左边第几个字符开始，及字符的个数
:<<!
	其中的 0 表示左边第一个字符开始，5 表示字符的总个数。
!
echo ${var:0:5}

# 6. 从左边第几个字符开始，一直到结束。
:<<!
	其中的 7 表示左边第8个字符开始，一直到结束。
!
echo ${var:7}

# 7. 从右边第几个字符开始，及字符的个数
:<<!
	其中的 0-7 表示右边算起第七个字符开始，3 表示字符的个数。
!
echo ${var:0-7:3}

# 8. 从右边第几个字符开始，一直到结束。
:<<!
	表示从右边第七个字符开始，一直到结束。
!
echo ${var:0-7}


# 字符比较
:<<!
if [ str1 = str2 ]		当两个串有相同内容、长度时为真 
if [ str1 != str2 ]		当串str1和str2不等时为真 
if [ -n str1 ]			当串的长度大于0时为真(串非空) 
if [ -z str1 ]			当串的长度为0时为真(空串) 
if [ str1 ]				当串str1为非空时为真
shell 中利用 -n 来判定字符串非空。
!

var=$*
if [ -n "$var" ]; then
	echo "with argument"
else
	echo "without argument"
fi

# 注意：中括号[  ]与其中间的代码应该有空格隔开
# 不加“”时该if语句等效于if [ -n ]，shell 会把它当成if [ str1 ]来处理，-n自然不为空，所以为正


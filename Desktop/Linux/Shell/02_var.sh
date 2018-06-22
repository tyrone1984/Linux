#!/bin/bash
you_name="linux"	#注意，变量名和等号之间不能有空格
echo $you_name		##使用一个定义过的变量，只要在变量名前面加美元符号即可
echo ${you_name}	#变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界

you_name="java"		#已定义的变量，可以被重新定义
echo you_name

# 只读变量
readonly myUrl="www.baidu.com"
echo $myUrl

# 删除变量 unset 命令不能删除只读变量
google="www.google.com"
echo $google
unset google	
echo $google  #此行执行将没有任何输出。

str='this is a string'
:<<!
单引号字符串的限制：

单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
单引号字串中不能出现单引号（对单引号使用转义符后也不行）。
!
name="www"
str="Hello, I konw you are \"$name\" "
echo $str

:<<!
双引号的优点：
双引号里可以有变量
双引号里可以出现转义字符
!

# 拼接字符串
your_name="qinjx"
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting $greeting_1

# 获取字符串长度
string="abcd"
echo ${#string}
echo
	
# # 查找子字符串
string="hello"
echo `expr $string = "hello"`

string="runoob is a great company"   
echo `expr index "$string" is`













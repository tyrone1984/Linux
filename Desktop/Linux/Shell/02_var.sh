#!/bin/bash
you_name="linux"	#注意，变量名和等号之间不能有空格
echo $you_name		##使用一个定义过的变量，只要在变量名前面加美元符号即可
echo ${you_name}	#变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界
you_name="java"		#已定义的变量，可以被重新定义
echo you_name

for file in $(ls ../Shell); do
	#statements
	echo $file	
done

echo -e ".任意字符:\n"
grep --color "hello." 11_grep.c 	# .任意字符

echo -e "hell匹配[a-z]:\n"
grep --color "hell[a-z]" 11_grep.c 	# hell匹配[a-z]

echo -e "[[:upper:]] 大写:\n"
grep --color "hello[[:upper:]]" 11_grep.c  # [[:upper:]] 大写

echo -e "^[[:upper:]] 无大写:\n"
grep --color "hello[^[:upper:]]" 11_grep.c 	# ^[[:upper:]] 无大写

echo -e "\n"
grep --color "hello[[:space:]][[:punct:]]" 11_grep.c 	# [[:upper:]] 无大写 空格 标点

echo -e "\n"
grep --color "hello[[:space:]][[:punct:]][[:space:]][[:digit:]]" 11_grep.c 	# [[:upper:]] 无大写 空格 标点 空格 数字

:<<!
匹配次数：

　　　　　　\{m,n\} ：匹配其前面出现的字符至少m次，至多n次。
　　　　　　\? ：匹配其前面出现的内容0次或1次，等价于\{0,1\}。
　　　　　　* ：匹配其前面出现的内容任意次，等价于\{0,\}，所以 ".*" 表述任意字符任意次，即无论什么内容全部匹配。
!
echo -e "匹配次数：\n"
grep --color ".*t" 11_grep.c

echo -e "\n"
grep --color ".\{0,2\}t" 11_grep.c

echo -e "\n"
grep -w --color ".\{0,2\}t" 11_grep.c 	# -w被匹配的文本只能是单词


:<<!
位置锚定：

　　　　　　^ ：锚定行首

　　　　　　$ ：锚定行尾。技巧："^$"用于匹配空白行。

　　　　　　\b或\<：锚定单词的词首。如"\blike"不会匹配alike，但是会匹配liker

　　　　　　\b或\>：锚定单词的词尾。如"\blike\b"不会匹配alike和liker，只会匹配like

　　　　　　\B ：与\b作用相反。
!


echo -e "锚定行首:\n"
grep --color "^int" 11_grep.c

echo -e "锚定行尾：\n"
grep --color ";$" 11_grep.c

echo -e "锚定单词的词首:\n"
grep --color "\<hell" 11_grep.c

echo -e "锚定单词的词尾:\n"
grep --color "\lo\>" 11_grep.c 		# grep --color "\lo\b" 11_grep.c

echo -e "\B:\n"
grep --color "\Blo" 11_grep.c

:<<!
分组及引用：

　　　　　　\(string\) ：将string作为一个整体方便后面引用

　　　　　　　　\1 ：引用第1个左括号及其对应的右括号所匹配的内容。

　　　　　　　　\2 ：引用第2个左括号及其对应的右括号所匹配的内容。

　　　　　　　　\n ：引用第n个左括号及其对应的右括号所匹配的内容。
!

#	以相同字母开始并结尾的行
echo -e "分组及引用：\n"
grep --color "^\([[:alpha:]]\).*\1$" 11_grep.c


:<<!
grep家族总共有三个：grep，egrep，fgrep。

常用选项：
　　-E ：开启扩展（Extend）的正则表达式。

　　-i ：忽略大小写（ignore case）。

　　-v ：反过来（invert），只打印没有匹配的，而匹配的反而不打印。

　　-n ：显示行号

　　-w ：被匹配的文本只能是单词，而不能是单词中的某一部分，如文本中有liker，而我搜寻的只是like，就可以使用-w选项来避免匹配liker

　　-c ：显示总共有多少行被匹配到了，而不是显示被匹配到的内容，注意如果同时使用-cv选项是显示有多少行没有被匹配到。

　　-o ：只显示被模式匹配到的字符串。

　　--color :将匹配到的内容以颜色高亮显示。

　　-A  n：显示匹配到的字符串所在的行及其后n行，after

　　-B  n：显示匹配到的字符串所在的行及其前n行，before

　　-C  n：显示匹配到的字符串所在的行及其前后各n行，context

模式部分： 　　1、直接输入要匹配的字符串，这个可以用fgrep（fast grep）代替来提高查找速度，比如我要匹配一下hello.c文件中printf的个数：grep  -c  "printf"  hello.c

2、使用基本正则表达式，下面谈关于基本正则表达式的使用：
　　　　匹配字符：

　　　　　　. ：任意一个字符。

　　　　　　[abc] ：表示匹配一个字符，这个字符必须是abc中的一个。

　　　　　　[a-zA-Z] ：表示匹配一个字符，这个字符必须是a-z或A-Z这52个字母中的一个。

　　　　　　[^123] ：匹配一个字符，这个字符是除了1、2、3以外的所有字符。

　　　　　　对于一些常用的字符集，系统做了定义：

　　　　　　[A-Za-z] 等价于 [[:alpha:]]

　　　　　　[0-9] 等价于 [[:digit:]]

　　　　　　[A-Za-z0-9] 等价于 [[:alnum:]]

　　　　　　tab,space 等空白字符 [[:space:]]

　　　　　　[A-Z] 等价于 [[:upper:]]

　　　　　　[a-z] 等价于 [[:lower:]]

　　　　　　标点符号 [[:punct:]]

!
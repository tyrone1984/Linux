# expr命令为Linux中的命令，一般用于整数值计算，但也可用于字符串操作。

LOOP=0
LOOP=`expr $LOOP + 1`	#使用 expr 命令时，表达式中的运算符左右必须包含空格，如果不包含空格，将会输出表达式本身:
echo $LOOP

# 对于某些运算符，还需要我们使用符号"\"进行转义，否则就会提示语法错误。

# expr 5 * 6     # 输出错误
expr 5 \* 6      # 输出30

# 如果试图计算非整数，将返回错误。
# rr=1.1
# expr $rr + 1

## 首先shell中0代表标准输入 ；1代表标准输出；2代表标准错误输出
:<<!
这里需要将一个值赋予变量（不管其内容如何），进行数值运算，并将输出导入dev/null，然后测试最后命令状态，
如果为0，证明这是一个数，其他则表明为非数值。
!
VALUE=12
expr $VALUE + 10 > /dev/null 2>&1	#标准输入重定向到null,将标准错误输出重定向到标准输出也就是输出到屏幕上
echo $?

VALUE=hello
expr $VALUE + 10 > /dev/null 2>&1
echo $?

VALUE=hello
echo `expr $VALUE = "hello"`
echo $?

:<<!
在Linux/Unix中，一般在屏幕上面看到的信息是从stdout (standard output) 或者 stderr (standard error output) 来的。许多人会问，output 就是 output，送到屏幕上不就得了，为什麼还要分成stdout 和 stderr 呢？那是因为通常在 server 的工作环境下，几乎所有的程序都是 run 在 background 的，所以呢，为了方便 debug，一般在设计程序时，就把stdout 送到/存到一个档案，把错误的信息 stderr 存到不同的档案。

可以将/dev/null看作"黑洞". 它非常等价于一个只写文件. 所有写入它的内容都会永远丢失. 而尝试从它那儿读取内容则什么也读不到. 
然而, /dev/null对命令行和脚本都非常的有用.


用处:

禁止标准输出.    1 cat $filename >/dev/null   # 文件内容丢失，而不会输出到标准输出. 
禁止标准错误.    2>/dev/null 这样错误信息[标准错误]就被丢掉了. 
!

:<<!

分解这个组合：“>/dev/null 2>&1” 为五部分。
1：> 代表重定向到哪里，例如：echo "123" > /home/123.txt
2：/dev/null 代表空设备文件
3：2> 表示stderr标准错误
4：& 表示等同于的意思，2>&1，表示2的输出重定向等同于1
5：1 表示stdout标准输出，系统默认值是1，所以">/dev/null"等同于 "1>/dev/null"

因此，>/dev/null 2>&1也可以写成“1> /dev/null 2> &1”

那么本文标题的语句执行过程为：
1>/dev/null ：首先表示标准输出重定向到空设备文件，也就是不输出任何信息到终端，说白了就是不显示任何信息。
2>&1 ：接着，标准错误输出重定向 到标准输出，因为之前标准输出已经重定向到了空设备文件，所以标准错误输出也重定向到空设备文件。
!

:<<!
变量	含义
$0	当前脚本的文件名
$n	传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。
$#	传递给脚本或函数的参数个数。
$*	传递给脚本或函数的所有参数。
$@	传递给脚本或函数的所有参数。被双引号(" ")包含时，与 $* 稍有不同，下面将会讲到。
$?	上个命令的退出状态，或函数的返回值。
$$	当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。
!

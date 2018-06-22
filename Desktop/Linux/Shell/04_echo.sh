### echo命令

#显示普通字符
echo "It is a test"

# 显示转义字符
echo "\"It is a test\""

# -e 开启转义
echo -e "OK! \n"
echo "It is a test"

# -e 开启转义 \c 不换行
echo -e "OK! \c"
echo "It is a test"

# 显示结果定向至文件
echo "It is a test" > myfile

# 原样输出字符串，不进行转义或取变量(用单引号)
echo '$name\"'

# 显示命令执行结果
echo `date`

# read 命令从标准输入中读取一行
# read -p "请输入一段字符:" name				#标准输入
# echo "$name is a test"

# read 命令一个一个词组地接收输入的参数，每个词组需要使用空格进行分隔；
# 如果输入的词组个数大于需要的参数个数，则多出的词组将被作为整体为最后一个参数接收。
# read firstStr secondStr
# echo "第一个参数:$firstStr; 第二个参数:$secondStr"

read -p "请输入一段文字:" -n 6 -t 5 -s password
echo -e "\npassword is $password"

# 参数说明：
#  -p 输入提示文字
#  -n 输入字符长度限制(达到6位，自动结束)
#  -t 输入限时
#  -s 隐藏输入内容



#创建文件到指定文件	要以EOF或STOP完毕
# cat > abc.txt << EOF
# a
# b
# c
# d
# e
# f
# EOF
echo $IFS | od -b
IFS="\\n"
value=$(cat abc.txt)
echo $value
IFS=$OLD_IFS
# IFS是shell脚本中的一个重要概念，在处理文本数据时，它是相当有用的。
# IFS可以是White Space（空白键）、Tab（ 表格键）、Enter（ 回车键）中的一个或几个。
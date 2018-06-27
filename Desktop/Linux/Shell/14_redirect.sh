:<<!
wc命令
利用wc指令我们可以计算文件的Byte数、字数、或是列数，若不指定文件名称、或是所给予的文件名为"-"，则wc指令会从标准输入设备读取数据。

参数：

-c或--bytes或--chars 只显示Bytes数。
-l或--lines 只显示行数。
-w或--words 只显示字数。
--help 在线帮助。
--version 显示版本信息

在默认的情况下，wc将计算指定文件的行数、字数，以及字节数。使用的命令为：
!

# 执行下面的 who 命令，它将命令的完整的输出重定向在用户文件中(users):
# 输出重定向会覆盖文件内容，请看下面的例子：
who > users

# 如果不希望文件内容被覆盖，可以使用 >> 追加到文件末尾，例如：
echo "菜鸟教程：www.runoob.com" >> users
cat users

## 输入重定向
## 这样，本来需要从键盘获取输入的命令会转移到文件读取内容。

wc -l users    # 会输出文件名

wc -l < users  # 不会输出文件名 因为它仅仅知道从标准输入读取内容。

# 同时替换输入和输出，执行command1，从文件infile读取内容，然后将输出写入到outfile中。
# command1 < infile > outfile
cat < users > users2

#
# 如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：

# command > file 2>&1

# 或者

# command >> file 2>&1

#
# 如果希望对 stdin 和 stdout 都重定向，可以这样写：
# $ command < file1 >file2		
# command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。
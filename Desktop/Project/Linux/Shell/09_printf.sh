###
printf "Hello, Shell\n"		#	默认 printf 不会像 echo 自动添加换行符，我们可以手动添加 \n。
#	%-10s 指一个宽度为10个字符（-表示左对齐，没有则表示右对齐）
# 	任何字符都会被显示在10个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。
# 	%-4.2f 指格式化为小数，其中.2指保留2位小数。
printf "%-10s %-10s %-10s\n" 姓名 性别 体重kg
printf "%-10s %-10s %-4.2f\n"  美美 女 60.123

# 如果没有 arguments，那么 %s 用NULL代替，%d 用 0 代替
printf "%s and %d \n" 

# 格式只指定了一个参数，但多出的参数仍然会按照该格式输出，format-string 被重用
printf %s abc def

# 没有引号也可以输出
# printf %s abcdef
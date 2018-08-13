#	# 数组
# 在Shell中，用括号来表示数组，数组元素用"空格"符号分割开
ary=(0 1 2 3 4)
value=${ary[1]}
echo $value

# 使用@符号可以获取数组中的所有元素
echo ${ary[@]}
echo ${ary[*]}

# 取得数组元素的个数
length=${#ary[@]}
echo $length

# 或者
length=${#ary[*]}
echo $length

# 取得数组单个元素的长度
lengthn=${#ary[1]}
echo $lengthn

echo "-------FOR循环遍历输出数组--------"
for i in ${ary[@]}; do
	echo $i
done

echo "-------::::WHILE循环输出 使用 let j++ 自增:::::---------"
j=0
while [ $j -lt ${#ary[@]} ]; do
	echo ${ary[$j]}
	let j++
done

echo "---------::::WHILE循环输出 使用 let m+=1 自增,这种写法其他编程中也常用::::----------"
m=0
while [ $m -lt ${#ary[*]} ]; do
	echo ${ary[$m]}
	let m+=1
done

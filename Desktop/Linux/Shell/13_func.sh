echo $-

demoFun()
{
	echo "This is my first Shell function"
}

echo "函数开始执行"
demoFun
echo "函数执行完毕"

funWithReturn()
{
	echo "这个函数会对输入的两个数字进行相加减运算..."
	read -p "请输入第一个数字: " aNum
	read -p "请输入第二个数字: " bNum
	echo "这两个数字分别是 $aNum 和 $bNum !"
	return $(($aNum+$bNum))
}

funWithReturn
echo "输入的两个数字之和为 $? !"

funWithParam()
{
	echo "第一个参数为$1!"
	echo "第一个参数为$2!"
	echo "第十个参数为$10!"
	echo "第十个参数为${10}!"
	echo "第十一个参数为${11}!"
	echo "参数的总数有$#个!"
	echo "作为一个字符串输出所有参数$*!"
}

funWithParam 1 2 3 4 5 6 7 8 9 20 11 
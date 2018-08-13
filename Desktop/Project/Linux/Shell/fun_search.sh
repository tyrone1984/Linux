
for file in $(ls .); do
	# echo $file
	if [[ "$#" -gt 0 ]]; then
		grep --color "$*" $file			# $*表示所有的输入参数
		if [ $(grep -c "$*" $file) -gt 0 ]; then
			echo $PWD/$file				
		fi
	else
		echo "没输入搜索参数"
		break
	fi
done

:<<!
将命令放在$()中执行，然后赋值给变量
result=$( ls -l )
echo $result
!
MAX_NUM=0
read -p "请输入大于2的数字:" MAX_NUM

if [[ MAX_NUM -lt 3 ]]; then
	echo "I ask to enter number great than 2, Try again"
	exit 1
fi

for (( i = 0; i < MAX_NUM; i++ )); do	
	k=i
	count=0
	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do
		if [[ k -lt MAX_NUM-1 || count -ge i*2+1 ]]; then
			echo -n "*"		
		else
			echo -n "."
			let count++
		fi		
		let k++
	done
	echo ""
done


for (( i = 0; i < MAX_NUM-1; i++ )); do	
	# k=`expr $MAX_NUM - $i \* 2`
	count=0	
	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do
		if [[ j -lt i+1 || count -ge MAX_NUM-i*2 ]]; then
			echo -n "*"	
		else
			echo -n "."
			let count++	
		fi		
	done
	echo ""
done


if [[ MAX_NUM -lt 3 ]]; then
	echo "I ask to enter number great than 2, Try again"
	exit 1
fi

for (( i = 0; i < MAX_NUM; i++ )); do	
	k=i
	count=0
	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do
		if [[ k -lt MAX_NUM-1 || count -ge i*2+1 ]]; then
			echo -n " "		
		else
			echo -n "."
			let count++
		fi		
		let k++
	done
	echo ""
done


for (( i = 0; i < MAX_NUM-1; i++ )); do	
	# k=`expr $MAX_NUM - $i \* 2`
	count=0	
	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do
		if [[ j -lt i+1 || count -ge MAX_NUM-i*2 ]]; then
			echo -n " "	
		else
			echo -n "."
			let count++	
		fi		
	done
	echo ""
done
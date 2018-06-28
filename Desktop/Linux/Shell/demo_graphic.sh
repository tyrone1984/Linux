MAX_NUM=0
read -p "请输入大于2的数字:" MAX_NUM

if [[ MAX_NUM -lt 3 ]]; then
	echo "I ask to enter number great than 2, Try again"
	exit 1
fi

for (( i = 0; i < MAX_NUM*2-1; i++ )); do
	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do		
		if [[ i -lt MAX_NUM ]]; then
			if [[ j -lt MAX_NUM-\(i+1\) || j -ge i+MAX_NUM ]]; then
				echo -n "*"
			else
				if [[ -n "$1" ]]; then
					echo -n "$1"
				else
					echo -n "."
				fi
			fi
		else
			if [[ j -lt i-\(MAX_NUM-1\) || j -gt 3*\(MAX_NUM-1\)-i ]]; then
				echo -n "*"	
			else
				if [[ -n "$1" ]]; then
					echo -n "$1"
				else
					echo -n "."
				fi
			fi
		fi
	done
	echo ""
done

# for (( i = 0; i < MAX_NUM-1; i++ )); do	
# 	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do
# 		if [[ j -lt i+1 || j -ge MAX_NUM*2-i-2 ]]; then
# 			echo -n " "	
# 		else
# 			if [[ -n "$1" ]]; then
# 				echo -n "$1"
# 			else
# 				echo "."
# 			fi
# 		fi
# 	done
# 	echo ""
# done


# for (( i = 0; i < MAX_NUM; i++ )); do
# 	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do		
# 		if [[ j -lt MAX_NUM-i-1 || j -ge i+MAX_NUM ]]; then
# 			echo -n " "
# 		else
# 			if [[ -n "$1" ]]; then
# 				echo -n "$1"
# 			else
# 				echo "."
# 			fi
# 		fi
# 	done
# 	echo ""
# done

# for (( i = 0; i < MAX_NUM-1; i++ )); do	
# 	for (( j = 0; j < MAX_NUM*2 - 1; j++ )); do
# 		if [[ j -lt i+1 || j -ge MAX_NUM*2-i-2 ]]; then
# 			echo -n " "	
# 		else
# 			if [[ -n "$1" ]]; then
# 				echo -n "$1"
# 			else
# 				echo "."
# 			fi
# 		fi
# 	done
# 	echo ""
# done
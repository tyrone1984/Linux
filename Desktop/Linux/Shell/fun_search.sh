
for file in $(ls .); do
	#statements
	echo $file	
	grep --color "echo -e" $file
	if [ $(grep -c "echo -e" $file) -gt 1 ]; then
		echo PWD/$file
	fi
	

done
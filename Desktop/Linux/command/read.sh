count=1
cat abc.txt | while read line 
do
	echo "Line$count:$line"
	count=$[ $count + 1]
done
echo "finish"
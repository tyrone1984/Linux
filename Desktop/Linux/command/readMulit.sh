vim temp.txt
IFS="\\n"
value=$(cat temp.txt)
echo $value
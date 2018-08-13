factorial()
{
	if [ "$1" -gt "1" ]; then
		i=`expr $1 - 1`
		j=`factorial $i`
		k=`expr $1 \* $j`
		echo $k
	else
		echo 1
	fi
}


while :
do
	read -p "Enter a number:" x
	factorial $x
done

#### 数值比较
:<<!
-gt是大于的意思。

-eq是等于的意思。

-ne是不等于的意思。

-ge是大于等于的意思。

-lt是小于的意思。

-le是小于等于的意思。
!
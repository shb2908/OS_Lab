#! /bin/bash

echo "Enter uv1 and uv2 values: "
read uv1 uv2

echo $uv1 , $uv2


# FINDING LENGTH OF VARS
len1=${#uv1}
len2=${#uv2}

echo -n "uv1 in reverse is: "

if [[ "$uv1" =~ ^[0-9a-zA-Z]+$ ]]; 
then
for (( i=$len1-1; i>=0; i-- )) # PRINTING IN REVERSE
do
	echo -n ${uv1:i:1}
done
else
echo -n "-"
for (( i=$len1-1; i>=1; i-- )) # PRINTING IN REVERSE
do
        echo -n ${uv1:i:1}
done
fi

echo 

echo -n "uv2 in reverse is: "

if [[ "$uv2" =~ ^[0-9a-zA-Z]+$ ]]; 
then
for (( i=$len2-1; i>=0; i-- )) # PRINTING IN REVERSE
do
        echo -n ${uv2:i:1}
done
else
echo -n "-"
for (( i=$len2-1; i>=1; i-- )) # PRINTING IN REVERSE
do
        echo -n ${uv2:i:1}
done
fi

echo


if ! [[ "$uv1" =~ ^-?[0-9]+$ ]]; 
then
	echo "not a number"; exit 1
fi
if ! [[ "$uv2" =~ ^-?[0-9]+$ ]]; then
	echo "not a number"; exit 1
fi

echo  -n "sum: "
echo  -n $(($uv1 + $uv2))
echo
exit 0

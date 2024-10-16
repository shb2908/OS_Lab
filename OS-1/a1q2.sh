#! /bin/bash

read -p "Enter filename: " filename

if [ -e $filename ] # CHECKING IF FILE EXISTS OR NOT
then
	echo "File exists..."
else
	echo "File doesn't exist.. creating..."
	touch $filename
	echo "Enter something to write to the file"
	read data
	echo $data > $filename
fi

# no of lines of file
echo -n "Number of lines in the file: "
wc -l < $filename
echo -n "Number of words in the file: $(wc -w < $filename)"


echo 

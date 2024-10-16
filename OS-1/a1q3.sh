#! /bin/bash

# RECURSIVE FUNCTION TO LIST ALL THE FILES 
# IN CURRENT DIRECTORY AND SUB-DIRECTORIES
listFiles(){
	for file in *
	do
		if [ -d $file ] # IF IT IS A DIRECTORY THEN CALL RECURSIVELY
		then
			cd $file
			listFiles $1/$file
			cd ..
		else
			echo $1/$file
		fi
	done
}


# PASSING THE CURRENT DIRECTORY AS ARGUMENT
listFiles "."


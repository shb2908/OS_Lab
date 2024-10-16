#!/bin/bash

takeDate(){
    user_date=$1

    # EXTRACTING DAY MONTH AND YEAR
    dd=${user_date:0:2}
    mm=${user_date:3:2}
    yy=${user_date:6:4}

    # ECHOING IN UNIX FORMAT
    date -d "$yy-$mm-$dd" +%A
}

calculateAge(){
    user_date=$1

    # EXTRACTING DAY MONTH AND YEAR
    dd=${user_date:0:2}
    mm=${user_date:3:2}
    yy=${user_date:6:4}

    # CURRENT DATE
    current_date=$(date +%Y-%m-%d)

    # CALCULATE AGE
    age=$(date -d "$current_date" +%Y)  # Current year
    birth_year=$yy
    age=$((age - birth_year))

    # Adjust age if birthday hasn't occurred yet this year
    if [ "$(date -d "$current_date" +%m%d)" -lt "$(date -d "$yy-$mm-$dd" +%m%d)" ]; then
        age=$((age - 1))
    fi

    echo $age
}

# TAKING THE TWO BIRTHDAYS
read -p "Enter first birthday (DD-MM-YYYY): " date1
read -p "Enter second birthday (DD-MM-YYYY): " date2

# TAKING THE DAY OF THE WEEK FROM THE FUNCTION
day1=$(takeDate "$date1")
day2=$(takeDate "$date2")

# CALCULATING AGES
age1=$(calculateAge "$date1")
age2=$(calculateAge "$date2")

# CHECKING WHETHER BOTH DAYS ARE SAME OR NOT
if [ "$day1" = "$day2" ]; then
    echo "Wow. Same day - $day1"
else
    echo "Different day - $day1 and $day2"
fi

# DISPLAYING AGES
echo "Age of the first person: $age1 years"
echo "Age of the second person: $age2 years"

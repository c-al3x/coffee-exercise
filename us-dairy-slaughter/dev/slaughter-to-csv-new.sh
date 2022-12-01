#!/bin/bash
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"

let "prev_entry_year=$(date -d "$(tail -n1 $1 | sed 's/\(.\+\),.\+,.\+,.\+,.\+,.\+,1/\1/')" +%Y)"
let "vol=$(tail -n1 $1 | sed 's/.\+,.\+,.\+,.\+,.\+,\(.*\),1/\1/')"
let "prev_vol=$(tail -n1 $1 | sed 's/.\+,.\+,.\+,.\+,.\+,\(.*\),1/\1/')"
prev_date=$(tail -n1 $1 | sed 's/\(.\+\),.\+,.\+,.\+,.\+,.\+,1/\1/')
prev_date=$(date -d "$prev_date" +%Y%m%d)
echo $prev_date

date_count="$(echo "$(echo $(echo "$(curl -s https://www.ams.usda.gov/mnreports/sj_ls714.txt)" | sed -n -e 7p -e 23p | sed -e 's~[[:space:]]*Week ending-\([[:digit:]]*/[[:digit:]]*/[[:digit:]]*\).*~\1~' -e 'N;s~U.S. 2/[[:space:]]\+\(\([0-9]\|,\)\{1,\}\).*~\1~') | sed -n -e 's/,//' -e 's/ /,/p')")"
date="$(echo $date_count | sed 's/\(.\+\),.\+/\1/')"

#date=$(date -d "$date"" -1 days" +%m/%d/%Y)
date=$(date -d "$date"" -1 days" +%Y%m%d)

# TODO: Check if USDA report is a correction of the previous report
# Should not default to exiting script if latest report is the same date
if [ "$(tail -n1 $1 | sed 's/\(.\+\),.\+,.\+,.\+,.\+,.\+,1/\1/')" = "$date" ];then
    echo ""
    echo "NORMALLY WILL EXIT HERE SINCE DATES MATCH BUT WILL CONTINUE FOR DEVELOPMENT PURPOSES"
    echo ""
    #exit 1
fi
count="$(echo $date_count | sed 's/.*,\(.*\)/\1/')"

# TODO: The zeroes can stay in the date, so the following block of lines are pointless
next_0=4
#if [ "${date:0:1}" = "0" ];then
#    date=${date:1}
#    next_0=3
#fi
#if [ "${date:$(($next_0 - 1)):1}" = "0" ];then
#    date=$(echo "$date" | cut --complement -c$next_0-$next_0)
#fi

year=$(echo $date | sed 's~.*/.*/\(.*\)~\1~')
year=$(echo $year | sed 's/\r//g')
if [ $prev_entry_year != $year ];then
    prev_entry_year=$year
    vol=$count
else
    let vol=vol+count
    let prev_vol=vol
fi

# TODO: If USDA report is a correction, then check that the date is correct
# Then, correct until the date where the previous report ended
# TODO: If USDA report is not dated on a Friday, then account for that as well
# Currently, this loop is assuming that the date turned to a Friday and report is not a correction

# Source: https://stackoverflow.com/questions/9008824/how-do-i-get-the-difference-between-two-dates-under-bash
let days_since_last_report=(`date +%s -d $date`-`date +%s -d $prev_date`)/86400
echo $date
echo $prev_date
echo $days_since_last_report
#echo $(date -d $date +%u)
day_of_week=$(date -d $date +%u)
echo $day_of_week
final_accumulation_day=0
if [ $day_of_week = 7 ] || [ $day_of_week = 6 ];then
    final_accumulation_day=$(echo "$day_of_week - 5" | bc)
fi

for ((i=$days_since_last_report-1; i>=0; i--))
do
    curr_date=$(date -d "$date"" -$i days" +%m/%d/%Y)
    curr_year=$(date -d $curr_date +%Y)
    curr_vol=$vol
    if [ $curr_year != $year ] && [ $prev_vol != 0 ];then
        let curr_vol=prev_vol+count
    fi

    if [ $i != $final_accumulation_day ];then
        curr_vol=1
	curr_day_of_week=$(date -d $curr_date +%u)
	echo "About to append an entry for the following date:"
	echo $curr_date
	echo $curr_day_of_week
	if [ $curr_day_of_week = 6 ] || [ $curr_day_of_week = 7 ];then
            continue
        fi
    fi
    echo "$curr_date,$count,$count,$count,$count,$curr_vol,1" >> $1 
done

echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"
echo "MAKE SURE TO EDIT THE CP COMMANDS FOR THE BOTTOM OF THIS SCRIPT!"

#sudo cp $1 /home/alex/OneDrive/fundamental_data/dairy/US/weekly_slaughter/dairy_US_weekly_slaughter.csv
#sudo cp /home/alex/usda-report-to-csv/testing/slaughter-to-csv.sh /home/alex/OneDrive/scripts/

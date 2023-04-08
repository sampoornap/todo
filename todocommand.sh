#!/bin/bash

declare -a lines=()
declare -a allduedates=()
lines=$(cat date.txt)
allduedates=($lines)
declare -a todoitem=()
lines=$(cat td.txt)
todoitem=($lines)
declare -a status=()
lines=$(cat todostatus.txt)
status=($lines)
todays_date=$(date -I)

add_todo()
{
    task=$1;
    due=$2;
    echo "$task" >> td.txt
    echo "$due" >> date.txt
    echo "n" >> todostatus.txt
}

add_todo_today()
{
    task=$1
    due=$(date -I)
    echo "$task" >> td.txt
    echo "$due" >> date.txt
    echo "n" >> todostatus.txt
}

display_todays_pending_todos()
{
    for date in ${!allduedates[@]};
    do
	if [[ "${allduedates[date]}" == "$todays_date" && ${status[date]} == "n" ]];
	then
	    echo "${todoitem[date]}"
	fi
    done
}

display_completed_tasks()
{
    for date in ${!allduedates[@]};
    do
	if [[ ${status[date]} == "y" ]];
	then
	    echo "${todoitem[date]}"
	fi
    done
}    

display_all_pending_todos()
{
    for date in ${!allduedates[@]};
    do
	if [[ ${status[date]} == "n" ]];
	then
	    echo "${todoitem[date]}"
	fi
    done
}

mark_todo_as_complete()
{
    marktodo=$1;
    
    sed -i "s/n/y/${marktodo}" todostatus.txt
    status[$((marktodo-1))]="y"
}



todo(){
    op=$1;
    
    if [[ $# -eq 4 ]];
    then
	if [[ $op == "-a" && $3 == "-d" ]];
	then
	    add_todo $2 $4
	else
	    echo "incorrect command"
	fi
	
    elif [[ $# -eq 2 ]];
    then
	if [[ $op == "-a" ]];
	then
	    add_todo_today $2
	elif [[ $op == "-s" ]];
	then
	    op_2=$2;
	    if [[ $op_2 == "-t" ]];
	    then
		display_todays_pending_todos 
	    elif [[ $op_2 == "-c" ]];
	    then
		display_completed_tasks
	    else
		echo "incorrect command"
	    fi
	elif [[ $op == "--done" ]];
	then
	    mark_todo_as_complete $2
	else
	    echo "incorrect command"
	fi
    elif [[ $# -eq 1 ]];
    then
	if [[ $op == "-s" ]];
	then
	    display_all_pending_todos
	elif [[ $op == "--help" ]];
	then
	    echo "-a => add todo item string"
	    echo "-d => deadline (yyyy-mm-dd)"
	    echo "-s => show todos"
	    echo "-t => today"
	    echo "-c => completed"
	    echo "--done => mark nth pending todo as completed"
	    
	else
	    echo "incorrect command"
	fi
    else
	echo "incorrect command"
    fi
}

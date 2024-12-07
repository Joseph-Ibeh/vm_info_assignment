#!/bin/bash

# Function to add color to output
color_text() {
    echo -e "\e[$1m$2\e[0m"
}

# Welcome message
color_text "32" "Welcome to VM Info Script!"

# Check if the user is root
if [ "$EUID" -eq 0 ]; then
    color_text "31" "Warning: You are running this script as root!"
else
    color_text "34" "You are not running this script as root. Proceeding..."
fi

# Display number of CPU cores
cpu_cores=$(nproc)
color_text "33" "Number of CPU cores: $cpu_cores"

# Display total amount of RAM
ram_total=$(free -h | awk '/^Mem:/ {print $2}')
color_text "33" "Total RAM: $ram_total"

# Display available disk space
disk_space=$(df -h / | awk 'NR==2 {print $4}')
color_text "33" "Available disk space: $disk_space"

# Display top 3 processes using the most CPU
color_text "33" "Top 3 processes by CPU usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 4 | awk '{printf "%-10s %-20s %s\n", $1, $2, $3}'

# Ask the user if they want to see current CPU usage
while true; do
    echo -n "Do you want to see current CPU usage? (yes/no): "
    read user_input

    if [[ "$user_input" == "yes" ]]; then
        color_text "36" "Showing CPU usage every 5 seconds. Press Ctrl+C to exit."
        while true; do
            top -b -n 1 | grep "Cpu(s)" | awk '{print "CPU Usage: "$2"%"}'
            sleep 5
        done
    elif [[ "$user_input" == "no" ]]; then
        color_text "32" "Goodbye! Thank you for using the VM Info Script."
        exit 0
    else
        color_text "31" "Invalid input. Please enter 'yes' or 'no'."
    fi
done


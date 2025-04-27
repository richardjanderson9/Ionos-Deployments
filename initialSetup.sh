#!/bin/bash

# Base directory and paths array
dirbase="/opt/rj-project"
declare -A dirs=(
    ["output"]="$dirbase/storage/output"
    ["changemanagement"]="$dirbase/storage/changemanagement"
    ["datafiles"]="$dirbase/storage/datafiles"
    ["configs"]="$dirbase/storage/configs"
    ["scripts"]="$dirbase/scripts"
)

# Define log file names
declare -A logfiles=(
    ["dirlog"]="1 - createdir.txt"
    ["scriptlog"]="2 - scriptchanges.txt"
    ["netdata"]="netdata.conf"
)

# Function to get current timestamp
get_timestamp() {
    date "+%d-%m-%y @ %H-%M-%S"
}

# Add separator for new run
echo "-------------------------------------------" >> "${dirs[changemanagement]}/${logfiles[dirlog]}"
echo "New Setup Run Starting: $(get_timestamp)" >> "${dirs[changemanagement]}/${logfiles[dirlog]}"
echo "-------------------------------------------" >> "${dirs[changemanagement]}/${logfiles[dirlog]}"

# Verify directories exist or create them
for dir in "${dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "$(get_timestamp) -- $dir -- Success" >> "${dirs[changemanagement]}/${logfiles[dirlog]}"
    else
        echo "$(get_timestamp) -- $dir -- Already Exists" >> "${dirs[changemanagement]}/${logfiles[dirlog]}"
    fi
done

# Move netdata.conf to storage/configs directory
mv "$dirbase/${logfiles[netdata]}" "${dirs[configs]}/${logfiles[netdata]}"

# Scan the scripts directory for all shell scripts and make them executable
for script in "${dirs[scripts]}"/*.sh; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        chmod +x "$script"
        echo "$(get_timestamp) -- $script_name -- Made Executable" >> "${dirs[changemanagement]}/${logfiles[scriptlog]}"
    fi
done

# Reboot the system
echo "Rebooting the system in 5 seconds..."
sleep 5
reboot
# End of script
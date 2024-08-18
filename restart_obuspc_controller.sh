#!/bin/bash

# Set constants
PROCESS_NAME="obuspc"
DB_PATH="/usr/local/var/usp/uspc.db"
CONFIG_FILE="./mqtt_default_configuration_reset.txt"
INTERFACE="lo"
LOG_FILE="/var/log/obuspa_restart.log"

log_message() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $message" | tee -a "$LOG_FILE"
}

log_message "Attempting to stop any running instances of $PROCESS_NAME..."
if pgrep "$PROCESS_NAME" > /dev/null 2>&1; then
    pkill "$PROCESS_NAME"
    if [ $? -eq 0 ]; then
        log_message "$PROCESS_NAME successfully stopped."
    else
        log_message "Failed to stop $PROCESS_NAME."
        exit 1
    fi
else
    log_message "No running instances of $PROCESS_NAME found."
fi

log_message "Attempting to remove the database file at $DB_PATH..."
if [ -f "$DB_PATH" ]; then
    rm -rf "$DB_PATH"
    if [ $? -eq 0 ]; then
        log_message "Database file removed successfully."
    else
        log_message "Failed to remove the database file."
        exit 1
    fi
else
    log_message "Database file not found, no need to remove."
fi

log_message "Starting $PROCESS_NAME with the provided configuration..."
obuspc -p -v 4 -r "$CONFIG_FILE" -i "$INTERFACE" &
if [ $? -eq 0 ]; then
    log_message "$PROCESS_NAME started successfully."
else
    log_message "Failed to start $PROCESS_NAME."
    exit 1
fi

#!/bin/bash

# Function to check the health of the virtual machine
check_health() {
    # Get CPU utilization
    cpu_utilization=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    
    # Get memory utilization
    memory_utilization=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    
    # Get disk utilization
    disk_utilization=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

    # Determine the health status
    if (( $(echo "$cpu_utilization < 60.0" | bc -l) )) && (( $(echo "$memory_utilization < 60.0" | bc -l) )) && (( $disk_utilization < 60 )); then
        status="Healthy"
    else
        status="Unhealthy"
    fi
}

# Function to explain the health status
explain_health() {
    echo "CPU utilization: $cpu_utilization%"
    echo "Memory utilization: $memory_utilization%"
    echo "Disk utilization: $disk_utilization%"
    echo "VM Status: $status"
}

# Main script
if [[ $1 == "explain" ]]; then
    check_health
    explain_health
else
    check_health
    echo "VM Status: $status"
fi

#!/bin/bash

# Set variables
ABUSEIPDB_API_KEY="ee8318a44fea92403abb24b208a93818272bf0a4e806111fa949aa42fde1a3356874d391e3d64320"  # Replace with your API key
LIST_PATH="/var/ossec/etc/lists/abuseipdb_blacklist"  # Path to your CDB list
TEMP_IP_LIST="/tmp/abuseipdb_ips.txt"  # Temporary file to store the IP list

# Fetch IPs from AbuseIPDB
echo "Fetching suspicious IPs from AbuseIPDB..."

# Replace 100 with your desired number of results (maximum 1000 per query)
curl -s "https://api.abuseipdb.com/api/v2/blacklist?maxAgeInDays=90&limit=1000" \
    -H "Key: $ABUSEIPDB_API_KEY" \
    -H "Accept: application/json" \
    -o $TEMP_IP_LIST

# Check if the request was successful
if [ $? -ne 0 ]; then
    echo "Failed to fetch data from AbuseIPDB."
    exit 1
fi

# Extract IPs from the response JSON and save them into a temporary file
echo "Extracting suspicious IPs..."

# Loop through each IP and append ":" to it before adding to the temporary file
jq -r '.data[] | .ipAddress' $TEMP_IP_LIST | while read ip; do
    # Check if the IP is already in the list to avoid duplication
    grep -q "$ip:" $LIST_PATH
    if [ $? -ne 0 ]; then
        # Append the IP to the list if it is not already present
        echo "$ip:" >> $LIST_PATH
    fi
done

# Set proper file permissions
chown wazuh:wazuh $LIST_PATH
chmod 660 $LIST_PATH

# Clean up temporary files
rm -f $TEMP_IP_LIST

echo "CDB list has been updated successfully."

# Restart Wazuh Manager to apply the changes
sudo systemctl restart wazuh-manager

echo "Wazuh Manager has been restarted to apply the new CDB list."

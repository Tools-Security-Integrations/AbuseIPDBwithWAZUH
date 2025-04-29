# AbuseIPDBwithWAZUH
This project integrates AbuseIPDB, a public IP reputation database, with the Wazuh SIEM platform to enable automated detection and blocking of malicious IP addresses.

Using this integration we can integrate AbuseIPDB api key with our wazuh to detect any "Sysmon - Event 3 Network connection log trigger the destination IP checked by suspicious ip's by our fetching suspicious ip's from AbuseIPDB" and this will work auto mode.

We target Original rule.id to extract "data.win.eventdata.destinationIp" : 61605

step 1. Create a script in  /var/ossec/etc/lists/(new folder)/fetch_abuseipdb_blacklist.sh

Step2: Give exicutable permission permission to the script 

       chmod 777 fetch_abuseipdb_blacklist.sh

       Before run this script need to install " sudo yum install jq "  # For CentOS/RHEL-based systems

Step 3: After that go to /var/ossec/etc/lists/ and check for newly created "abuseipdb_blacklist" list.

Step 4: After creating the list, we need to tell Wazuh to load this list. Wazuh will generate the .cdb file on the fly for us.

 nano /var/ossec/etc/ossec.conf


       Find the <ruleset> section and add our new list.


       <list>etc/lists/abuseipdb_blacklist</list>

Step 5: systemctl restart wazuh-manager

Step 6: add rule, nano /var/ossec/etc/rules/local_rules.xml

Step 7: systemctl restart wazuh-manager


# Script to setup autoprovision, and password on the mangager 
# to run do the following cat > mgr.sh (paste this in) then chmod 755 mgr.sh; ./mgr.sh

curl_cli https://s3.amazonaws.com/chkp-images/autoprovision-addon.tgz -k -o /tmp/autoprovision-addon.tgz;
service autoprovision stop;
tar zxfC /tmp/autoprovision-addon.tgz /;
chkconfig --add autoprovision;
service autoprovision start;
# Check that the manager has started before trying to add rules 
$CPMDIR/scripts/check_cpm_status.sh > cpm_started.status;
if [ $? -eq 1 ]
then
  echo "Successfully started manager" >> cpm_started.status
  $MDS_FWDIR/scripts/cpm_status.sh >> cpm_started.status
else
  echo "Something went wrong, error code $?"  >> cpm_started.status
  exit
fi;
cloudguard on;
sleep 2
# Management rules 
mgmt_cli -r true set access-rule layer Network rule-number 1 action "Accept" track "Log" ;
mgmt_cli -r true add access-layer name "Inline" ;
mgmt_cli -r true set access-rule layer Inline rule-number 1 action "Accept" track "Log" ;
mgmt_cli -r true add nat-rule package standard position bottom install-on "Policy Targets" original-source All_Internet translated-source All_Internet method hide ;
clish -c 'set user admin password-hash $1$8SfURQQf$' -s
# setup autoprovisioning (azure mspn login) 
autoprov-cfg -f init Azure -mn mgmr80 -tn Demo-auto -otp vpn12345 -ver R80.20 -po Standard -cn AzureDC -sb xxxxxxxx -at xxxxxxxx -aci xxxxxxxxxxx -acs xxxxxxx
autoprov-cfg -f set template -tn Demo-auto -appi -uf -hi -ips -ab -av -ia ;

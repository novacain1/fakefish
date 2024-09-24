#!/bin/bash

#### IMPORTANT: This script translates to an openBMC format so that it is compatible with metal3.
#### This particular BMC requires that the virtual media server's SSL certificate is imported into the BMC!
#### This script has to poweron the server and return 0 if operation succeeded, 1 otherwise
#### You will get the following vars as environment vars
#### BMC_ENDPOINT - Has the BMC IP
#### BMC_USERNAME - Has the username configured in the BMH/InstallConfig and that is used to access BMC_ENDPOINT
#### BMC_PASSWORD - Has the password configured in the BMH/InstallConfig and that is used to access BMC_ENDPOINT

curl -X POST -s -k -u ''"${BMC_USERNAME}"'':''"${BMC_PASSWORD}"'' https://${BMC_ENDPOINT}/redfish/v1/Systems/system/Actions/ComputerSystem.Reset -d '{"ResetType":"ForceOn"}'
if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi
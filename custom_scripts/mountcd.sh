#!/bin/bash

#### IMPORTANT: This script translates to an openBMC format so that it is compatible with metal3.
#### This particular BMC requires that the virtual media server's SSL certificate is imported into the BMC!
#### This script has to mount the iso in the server's virtualmedia and return 0 if operation succeeded, 1 otherwise
#### Note: Iso image to mount will be received as the first argument ($1)
#### You will get the following vars as environment vars
#### BMC_ENDPOINT - Has the BMC IP
#### BMC_USERNAME - Has the username configured in the BMH/InstallConfig and that is used to access BMC_ENDPOINT
#### BMC_PASSWORD - Has the password configured in the BMH/InstallConfig and that is used to access BMC_ENDPOINT

ISO=${1}

# Configure remote media, in case it is not already enabled
#echo
#curl -X POST -s -k -u ''"${BMC_USERNAME}"'':''"${BMC_PASSWORD}"'' https://${BMC_ENDPOINT}/redfish/v1/Managers/Self/Actions/Oem/AMIVirtualMedia.EnableRMedia --data '{"RmediaState": "Enable"}' -H "Content-type: application/json"

# Unmount image just in case
curl -X POST -s -k -u ''"${BMC_USERNAME}"'':''"${BMC_PASSWORD}"'' https://${BMC_ENDPOINT}/redfish/v1/Managers/bmc/VirtualMedia/Slot_2/Actions/VirtualMedia.EjectMedia -d ""

# Mount the image
IMAGE_JSON="{\"Image\": \"${ISO}\"}"
curl -X POST -s -k -u ''"${BMC_USERNAME}"'':''"${BMC_PASSWORD}"'' https://${BMC_ENDPOINT}/redfish/v1/Managers/bmc/VirtualMedia/Slot_2/Actions/VirtualMedia.InsertMedia -d "${IMAGE_JSON}" -H "Content-Type: application/json"

if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi

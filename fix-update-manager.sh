#!/bin/bash

service-control --stop vsphere-ui
service-control --stop vsphere-client

VERSION=`python /usr/lib/vmidentity/tools/scripts/lstool.py list --url http://localhost:7080/lookupservice/sdk --type client --product com.vmware.vum 2>&1 | grep Version | awk '{print $2}'`

curl --insecure https://localhost:9087/vci/downloads/vum-htmlclient.zip --output vum-htmlclient.zip
curl --insecure https://localhost:9087/vci/downloads/vumclient.zip --output vumclient.zip

rm -fr /etc/vmware/vsphere-ui/cm-service-packages/com.vmware.cis.vsphereclient.plugin/com.vmware.vum.client-$VERSION
rm -fr /etc/vmware/vsphere-client/cm-service-packages/com.vmware.cis.vsphereclient.plugin/com.vmware.vcIntegrity-$VERSION

unzip vum-htmlclient.zip -d /etc/vmware/vsphere-ui/cm-service-packages/com.vmware.cis.vsphereclient.plugin/com.vmware.vum.client-$VERSION
unzip vumclient.zip -d /etc/vmware/vsphere-client/cm-service-packages/com.vmware.cis.vsphereclient.plugin/com.vmware.vcIntegrity-$VERSION

chown -R vsphere-ui /etc/vmware/vsphere-ui/cm-service-packages/com.vmware.cis.vsphereclient.plugin/com.vmware.vum.client-$VERSION
chown -R vsphere-client /etc/vmware/vsphere-client/cm-service-packages/com.vmware.cis.vsphereclient.plugin/com.vmware.vcIntegrity-$VERSION

rm -f vum-htmlclient.zip
rm -f vumclient.zip

service-control --start vsphere-ui
service-control --start vsphere-client

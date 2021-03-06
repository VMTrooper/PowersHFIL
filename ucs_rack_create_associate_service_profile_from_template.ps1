
#Substitue servername\IP below
Connect-Ucs <ucs server> -Credential (Get-Credential)
 #need to make this loop a bit more intelligent so that we don't have to fiddle with tens place
 
for ($i=0; $i -le 3; $i++) {
  #add-ucsserviceprofile -name nova-00$i -SrcTemplName Nova-Server-ephemeral
  #add-ucsserviceprofile -name nova-01$i -SrcTemplName Nova-Server-ephemeral
  #add-ucsserviceprofile -name nova-02$i -SrcTemplName Nova-Server-ephemeral
  add-ucsserviceprofile -name mgmt-00$i -SrcTemplName Nova-Server-ephemeral
}
add-ucsserviceprofile -name infra-003 -SrcTemplName Nova-Server-ephemeral
add-ucsserviceprofile -name infra-004 -SrcTemplName Nova-Server-ephemeral

#Need to make smart loops for the following statements...

#Associate Infrastructure Nodes
connect-ucsserviceprofile -serviceprofile infra-002 -rackunit 2 -force
connect-ucsserviceprofile -serviceprofile infra-003 -rackunit 3 -force
connect-ucsserviceprofile -serviceprofile infra-004 -rackunit 4 -force

#Associate Management Nodes
for ($i=1; $i -le 3; $i++) {
  connect-ucsserviceprofile -serviceprofile mgmt-00$i -rackunit ($i+4).tostring() -force
}

#Associate Compute Nodes
for ($i=1; $i -le 25; $i++) {
  if ($i -lt 10) {
    connect-ucsserviceprofile -serviceprofile nova-00$i -rackunit ($i+7).tostring() -force
  }
  else {
    connect-ucsserviceprofile -serviceprofile nova-0$i -rackunit ($i+7).tostring() -force
  }
}


connect-ucsserviceprofile -serviceprofile net-002 -blade 2/1 -force
connect-ucsserviceprofile -serviceprofile net-003 -blade 3/1 -force
connect-ucsserviceprofile -serviceprofile net-004 -blade 4/1 -force
connect-ucsserviceprofile -serviceprofile proxy-001 -blade 1/2 -force
connect-ucsserviceprofile -serviceprofile proxy-002 -blade 2/2 -force

#Compute Servers
connect-ucsserviceprofile -serviceprofile nova-001 -blade 1/3 -force
connect-ucsserviceprofile -serviceprofile nova-002 -blade 1/4 -force
connect-ucsserviceprofile -serviceprofile nova-003 -blade 1/5 -force
connect-ucsserviceprofile -serviceprofile nova-004 -blade 1/6 -force
connect-ucsserviceprofile -serviceprofile nova-005 -blade 1/7 -force
connect-ucsserviceprofile -serviceprofile nova-006 -blade 1/8 -force
connect-ucsserviceprofile -serviceprofile nova-007 -blade 2/3 -force
connect-ucsserviceprofile -serviceprofile nova-008 -blade 2/4 -force
connect-ucsserviceprofile -serviceprofile nova-009 -blade 2/5 -force
connect-ucsserviceprofile -serviceprofile nova-010 -blade 2/6 -force
connect-ucsserviceprofile -serviceprofile nova-011 -blade 2/7 -force
connect-ucsserviceprofile -serviceprofile nova-012 -blade 2/8 -force
connect-ucsserviceprofile -serviceprofile nova-013 -blade 3/2 -force
connect-ucsserviceprofile -serviceprofile nova-014 -blade 3/3 -force
connect-ucsserviceprofile -serviceprofile nova-015 -blade 3/4 -force
connect-ucsserviceprofile -serviceprofile nova-016 -blade 3/5 -force
connect-ucsserviceprofile -serviceprofile nova-017 -blade 3/6 -force
connect-ucsserviceprofile -serviceprofile nova-018 -blade 3/7 -force
connect-ucsserviceprofile -serviceprofile nova-019 -blade 3/8 -force
connect-ucsserviceprofile -serviceprofile nova-020 -blade 4/2 -force
connect-ucsserviceprofile -serviceprofile nova-021 -blade 4/3 -force
connect-ucsserviceprofile -serviceprofile nova-022 -blade 4/4 -force
connect-ucsserviceprofile -serviceprofile nova-023 -blade 4/5 -force
connect-ucsserviceprofile -serviceprofile nova-024 -blade 4/6 -force
connect-ucsserviceprofile -serviceprofile nova-025 -blade 4/7 -force
connect-ucsserviceprofile -serviceprofile nova-026 -blade 4/8 -force
connect-ucsserviceprofile -serviceprofile nova-027 -blade 5/1 -force
connect-ucsserviceprofile -serviceprofile nova-028 -blade 5/2 -force
connect-ucsserviceprofile -serviceprofile nova-029 -blade 5/3 -force
connect-ucsserviceprofile -serviceprofile nova-030 -blade 5/4 -force
connect-ucsserviceprofile -serviceprofile nova-031 -blade 5/5 -force
connect-ucsserviceprofile -serviceprofile nova-032 -blade 5/6 -force
connect-ucsserviceprofile -serviceprofile nova-033 -blade 5/7 -force
connect-ucsserviceprofile -serviceprofile nova-034 -blade 5/8 -force

#Disassociate multiple servers...because reasons

#Disconnect-UcsServiceProfile -ServiceProfile nova-001 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-002 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-003 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-004 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-005 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-006 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-007 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-008 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-009 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-010 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-011 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-012 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-013 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-014 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-015 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-016 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-017 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-018 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-019 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-020 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-021 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-022 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-023 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-024 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-025 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-026 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-027 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-028 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-029 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-030 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-031 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-032 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-033 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-034 -force
#Disconnect-UcsServiceProfile -ServiceProfile nova-035 -force

#End Session
Disconnect-Ucs
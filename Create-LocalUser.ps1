#Create a Local user in the Computer and Add user to local admin group

$Localuseraccount = @{
   Name = "Adam"
   Password = ("P@55W0rd@100" | ConvertTo-SecureString -AsPlainText -Force)
   AccountNeverExpires = $True
   PasswordNeverExpires = $True
   Verbose = $True
}

New-LocalUser @Localuseraccount

Add-LocalGroupMember -Group Administrators -Member $Localuseraccount.Name -Verbose

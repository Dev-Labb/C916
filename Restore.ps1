# Author: Kerry Daniels Student ID: 001548730

#Creates a new OU called "Fianance"
New-ADOrganizationalUnit -Path "DC=consultingfirm,DC=com" -Name "Finance" -DisplayName "Finance-Dept" -ProtectedFromAccidentalDeletion $false 

#Imports CSV and sets path to correct OU
$ADUsers = Import-Csv -path $PSScriptRoot\financePersonnel.csv
$Path = "OU=Finance,DC=consultingfirm,DC=com"



foreach ($ADUser in $ADUsers) {
    $FirstName = $ADUser.First_Name  
    $LastName = $ADUser.Last_Name 
    $FullName = $FirstName + " " + $LastName 
    $SAM = $ADUser.samaccount
    $Postal = $ADUser.PostalCode 
    $Office = $ADUser.OfficePhone
    $Mobile = $ADUser.MobilePhone


    New-ADUser  -GivenName $FirstName `
                -Surname $LastName `
                -Name $FullName `
                -SamAccountName $SAM `
                -DisplayName $FullName `
                -PostalCode $Postal `
                -OfficePhone $Office `
                -MobilePhone $Mobile `
                -path $Path 
                
}

# Author: Kerry Daniels Student ID: 001548730

#Creates a new OU called "Fianance"
New-ADOrganizationalUnit -Path "DC=consultingfirm,DC=com" -Name "Finance" -DisplayName "Finance-Dept" -ProtectedFromAccidentalDeletion $false 

#Imports CSV and sets path to correct OU
$ADUsers = Import-Csv -path $PSScriptRoot\financePersonnel.csv
$Path = "OU=Finance,DC=consultingfirm,DC=com"


#Loops through CSV file for each user within
foreach ($ADUser in $ADUsers) {
    
    #Sets variables for each users credentials within the CSV
    $FirstName = $ADUser.First_Name  
    $LastName = $ADUser.Last_Name 
    $FullName = $FirstName + " " + $LastName 
    $SAM = $ADUser.samaccount
    $Postal = $ADUser.PostalCode 
    $Office = $ADUser.OfficePhone
    $Mobile = $ADUser.MobilePhone

    #Creates users utilizing above variable/credentials and adds them to specified "Path"
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

#Checks to see if old outdated sql module is imported alerady and if so removes it. 
if (Get-Module sqlps) { Remove-Module sqlps }

#Imports current SQL module 
Get-Module -Name SqlServer

#Sets appropitate variable for referencing a Server and Database instance. 
$NewServer = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList ".\SQLEXPRESS"
$NewDB = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $NewServer, ClientDB 

#creates the the database. 
$NewDB.Create()

#Creates teh table within the Database based on the T-SQL code in our Source folder.
Invoke-Sqlcmd -ServerInstance   -Database $NewDB -InputFile $PSScriptRoot\Client_A_Contacts.sql 

#Variable for referencing our created table vs having to type it in every time. 
$tableName = "Client_A_Contacts" 
$ClientServer = "SRV19-PRIMARY\SQLEXPRESS" 
$ClientDB = "ClientDB"

#Varible for injecting credentials into "Client_A_Contacts" table. 
$Insert = "INSERT INTO [$($tableName)] (first_name, last_Name, city, county, zip, officePhone, mobilePhone) "

#Variable to import proper csv for clients.
$NewClients = Import-Csv $PSScriptRoot\NewClientData.csv 

#Loop that will cycl through each client and add appropiate credentials to correct location inside "Client_A_Contacts" table. 
foreach($NewClient in $NewClients)
{
    $Credentials = "VALUES (`
                            '$($NewClient.first_name)' , `
                            '$($NewClient.last_name)' , `
                            '$($NewClient.city)' , `
                            '$($NewClient.county)' , `
                            '$($NewClient.zip)' , `
                            '$($NewClient.OfficePhone)' , `
                            '$($NewClient.MobilePhone)' , )"
}

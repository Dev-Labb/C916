# Author: Kerry Daniels Student ID: 001548730

#Creates a new OU called "Fianance"
New-ADOrganizationalUnit -Path "DC=consultingfirm,DC=com" -Name "Finance" -DisplayName "Finance-Dept" -ProtectedFromAccidentalDeletion $false 

#Imports CSV and sets path to correct OU for new users to be added to from CSV. 
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

#Variable for referencing table, server, and Database. 
$TableName = "Client_A_Contacts" 
$ClientServer = "SRV19-PRIMARY\SQLEXPRESS" 
$ClientDB = "ClientDB"

#creates the the database. 
$NewDB.Create()

#Creates the table within the Database based on the T-SQL code in our Source folder.
Invoke-Sqlcmd -ServerInstance $ClientServer -Database $ClientDB -InputFile $PSScriptRoot\Client_A_Contacts.sql 

#Varible for injecting credentials into "Client_A_Contacts" table. 
$Insert = "INSERT INTO [$($TableName)] (first_name, last_name, city, county, zip, officePhone, mobilePhone) "

#Variable to import proper csv for clients.
$NewClients = Import-Csv $PSScriptRoot\NewClientData.csv 

#Loop that will cycl through each client and add appropiate credentials to correct location inside "Client_A_Contacts" table. 
foreach($NewClient in $NewClients)
{
    $Credentials = "VALUES ( `
                            '$($NewClient.first_name)' , `
                            '$($NewClient.last_name)' , `
                            '$($NewClient.city)' , `
                            '$($NewClient.county)' , `
                            '$($NewClient.zip)' , `
                            '$($NewClient.officePhone)' , `
                            '$($NewClient.mobilePhone)')"

#Following will add variable for the following SQL query and then add new clients to "Client_A_Contacts" table.
$AddClients = $Insert + $Credentials
Invoke-Sqlcmd -Database $ClientDB -ServerInstance $ClientServer -Query $AddClients 

}

# Author Kerry Daniels

$DesiredDomain = "DC=consultingfirm,DC=com"
$DesiredOUName = "Finance"
$DesiredDisplayName = "FinanceDept"

New-ADOrganizationalUnit -Path $DesiredDomain -Name $DesiredOUName -DisplayName $DesiredDisplayName -ProtectedFromAccidentalDeletion = $false


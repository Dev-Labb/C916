<### Author Kerry Daniels Student ID#001548730 ###

Synopsis:
This script is to complete all the tasks assigned in Task 1 of C916 WGU Course.

Description
<#This script runs a switch statement that will perform helpful functions based on the option (number 1-5) the user inputs. 


##Try is for exception/error handling. Tries the script block specified and runs the catch if error occurs.#>

try
{

  #The "num" variable will carry the value of the number user presses. 
  $num = 0
  
  #while loop will continue to run script block until the number 5 is pressed.
  while($num -ne 5)
  {
    #Creates a menu for user to select from
    Write-Host -ForegroundColor DarkCyan "
    1. Consolidate logs into daily log file
    2. Gather all requirements
    3. Monitor CPU and Memory usage
    4. Get organized list of running processes
    5. Exit script
    "

    Write-Host -ForegroundColor DarkCyan "Please select a number 1-5 from the menu"
    $num = Read-Host


    #swtich statement acts as an if/elfif statement and will perform functions based on the user's input 1-4.
    switch ($num)
    {
        
          #Next line grabs all files with the ".log" extensioin and outputs it to a fle named "dailylog.txt" with date.
          1 {Get-ChildItem -path $PSScriptRoot *.log* | get-date | out-file $PSScriptRoot\dailylog.txt -Append}
          #Next line grabs all contents in the Requirments1 folder and outputs it in text to C916contents.txt file.
          2 {get-childitem -Path  $PSScriptRoot | Sort-Object | out-file $PSScriptRoot\C916contents.txt} 
          #Next line will output Memory and CPU usge info.
          3 {get-counter '\Memory\Committed Bytes', '\Processor(_Total)\% Processor Time'}
          ##Next line will get current running processes and sort them by virtual size least to greatest. 
          4 {Get-Process | Sort-Object VirtualMemorySize | Out-GridView}
          #Next Line Quits script
          5 {Write-Host -ForegroundColor Red "Exiting Script..."}
          #Next line runs if user does not selcet options 1-5 and tells them to do so.
          Default {Read-Host "You did not enter a number 1-5. Please only choose numbers 1-5."}
    }
  }      
}  

#Catch runs when memory eror occurs. Tells user the issue and exits the script. 
Catch [System.OutOfMemoryException]
{
        Write-Host -ForegroundColor Red "Out of Memory. Terminating Script."
        Exit
}   
    



clear 
$UserName = "<Fill this>"  
$Password = "<Fill this>"

$cred = Get-Credential

@("LOVAK26504A") | % {
$ServerN = $_
#$ServiceName = "vstsagent.mseng.$ServerN"
$ServiceName = "vstsagent.mseng.$ServerN" + "DeploymentGrp"
Write-Host $ServerN
Write-Host $ServiceName

$svcD = Get-WmiObject -computername $ServerN -Class Win32_Service -Filter  "name='$ServiceName'" -Credential $cred

Write-Host $svcD.Name

$StopStatus = $svcD.StopService() 
If ($StopStatus.ReturnValue -eq "0") # validating status - http://msdn.microsoft.com/en-us/library/aa393673(v=vs.85).aspx 
    {write-host "$ServerN -> Service Stopped Successfully"} 
$ChangeStatus = $svcD.change($null,$null,$null,$null,$null,$null,$UserName,$Password,$null,$null,$null) 
If ($ChangeStatus.ReturnValue -eq "0")  
    {write-host "$ServerN -> Sucessfully Changed User Name and password"} 
$StartStatus = $svcD.StartService() 
If ($ChangeStatus.ReturnValue -eq "0")  
    {write-host "$ServerN -> Service Started Successfully"} 
}
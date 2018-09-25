$UserName = "<Fill this>"  
$Password = "<Fill this>"


#$cred = Get-Credential
$SecureString = ConvertTo-SecureString -AsPlainText $Password -Force

$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName,$SecureString

@("LOVAK43175A", "LOVAK43176A", "LOVAK43177A") | % {

    $ServerN = $_
    Restart-Computer -ComputerName $ServerN -Credential $creds -Force

    Write-Host $ServerN
}
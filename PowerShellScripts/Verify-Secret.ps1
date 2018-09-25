param ([string] $SecretValue)

$ExpectedSecretValue = "Line1
Line2
Line3
Line4"

Write-Host $SecretValue

if ($multilineStr.Equals($SecretValue)) { 
    Write-Host "Secrets matched"; 
} else { 
    Write-Error "Secrets did not match"; 
}
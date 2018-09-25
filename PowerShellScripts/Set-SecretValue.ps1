$multilineStr = "Line1
Line2
Line3
Line4"

#$multilineStr = "Line1\nLine2\nLine3\nLine4"


#$multilineStr
$password = convertto-securestring $multilineStr -asplaintext -force

Set-AzureKeyVaultSecret -VaultName RmCdpKeyVault -Name kv-multiline -SecretValue $password

$sstr = (Get-AzureKeyVaultSecret -VaultName RmCdpKeyVault -Name kv-multiline).SecretValue
$marshal = [System.Runtime.InteropServices.Marshal]
$ptr = $marshal::SecureStringToBSTR( $sstr )
$str = $marshal::PtrToStringBSTR( $ptr )
$marshal::ZeroFreeBSTR( $ptr )
$str


if ($str.Equals($multilineStr)) { 
    Write-Host "Secrets matched"; 
} else { 
    Write-Error "Secrets did not match"; 
}
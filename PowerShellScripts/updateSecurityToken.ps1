param (
    [string] $PatToken,
    [string] $ReleaseDefinitionId
)


$ErrorActionPreference = "Stop"

if ((-not $PatToken) -or (-not $releaseDefinitionId))
{
   Write-Error "PAT or ReleaseDefinitionId missing"
}


$updateSecurityTokenUrl = 'https://mseng.visualstudio.com/b924d696-3eae-4116-8443-9a18392d8544/_api/_security/ManagePermissions?__v=5'

$basicAuth = ("{0}:{1}" -f "DummyValue", $PatToken)
$basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth)
$basicAuth = [System.Convert]::ToBase64String($basicAuth)
$headers = @{Authorization=("Basic {0}" -f $basicAuth)}

$payloadJson= '{"updatePackage":"{\"IsRemovingIdentity\":false,\"TeamFoundationId\":\"81340b66-c467-403f-8913-34df9a5fe2f8\",\"DescriptorIdentityType\":\"Microsoft.TeamFoundation.Identity\",\"DescriptorIdentifier\":\"S-1-9-1551374245-2530616505-2923304513-2219022872-959284548-1-1149527310-2482059343-2930185346-130768236\",\"PermissionSetId\":\"c788c23e-1b46-4162-8f5e-d7585343b5de\",\"PermissionSetToken\":\"b924d696-3eae-4116-8443-9a18392d8544/'+ $ReleaseDefinitionId + '\",\"RefreshIdentities\":false,\"Updates\":[{\"PermissionId\":1,\"PermissionBit\":512,\"NamespaceId\":\"c788c23e-1b46-4162-8f5e-d7585343b5de\",\"Token\":\"b924d696-3eae-4116-8443-9a18392d8544/'+ $ReleaseDefinitionId + '\"}],\"TokenDisplayName\":null}"}'
Write-Output "payloadJson: $payloadJson"

Invoke-RestMethod -Uri $updateSecurityTokenUrl -headers $headers -ContentType 'application/json' -Method POST -Body $payloadJson

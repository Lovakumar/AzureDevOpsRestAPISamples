param (
        [string] $PatToken,
        [string] $VstsAccount,
        [string] $ProjectId,
        [string] $ProjectName,
        [string] $ReleaseDefinitionId,
        [string] $BuildDefinitionId,
        [string] $BuildDefinitionName
)

#To write usage message
function Write-UsageMessage
{
   Write-Output "Syntax: LinkBuildDefinitionToReleaseDefinition.ps1 -PatToken <PatToken> -VstsAccount <VstsAccount> -ProjectId <ProjectId> -ProjectName <ProjectName> -ReleaseDefinitionId <ReleaseDefinitionId> -ReleaseDefinitionId <ReleaseDefinitionId> -BuildDefinitionName <BuildDefinitionName>"
}

if ((-not $PatToken) -or (-not $VstsAccount) -or (-not $ProjectId) -or (-not $ProjectName) -Or (-not $ReleaseDefinitionId) -or (-not $BuildDefinitionId) -or (-not $BuildDefinitionName) )
{
   Write-UsageMessage
   throw
}

$ErrorActionPreference = "Stop"

$getRDUrl = 'https://' + $VstsAccount + '.vsrm.visualstudio.com/' + $ProjectName + '/_apis/Release/definitions/' + $ReleaseDefinitionId
$putRDUrl = 'https://' + $VstsAccount + '.vsrm.visualstudio.com/' + $ProjectName + '/_apis/Release/definitions/?api-version=5.0-preview.3'

$basicAuth = ("{0}:{1}" -f "DummyValue", $PatToken)
$basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth)
$basicAuth = [System.Convert]::ToBase64String($basicAuth)
$headers = @{Authorization=("Basic {0}" -f $basicAuth)}


#Download RD Json
$downloadedRDJson = (Invoke-RestMethod -Uri $getRDUrl -headers $headers -Method Get)
Write-Output "downloadedRDJson: $downloadedRDJson"

#Link BD to RD
$modifiedRD= ($downloadedRDJson | ConvertTo-Json -Depth 20 -Compress) | ConvertFrom-Json

$definition = [PSCustomObject]@{
    id = $BuildDefinitionId
    name = $BuildDefinitionName
}

$defaultVersionType = [PSCustomObject]@{
    id = 'latestType'
    name = 'Latest'
}

$project = [PSCustomObject]@{
    id = $ProjectId
    name = $ProjectName
}

$definitionReference = [PSCustomObject]@{
    definition = $definition
    project = $project
    defaultVersionType = $defaultVersionType
}

$buildArtifact = [PSCustomObject]@{
    type = "Build"
    isPrimary = "true"
    alias = $BuildDefinitionName
    definitionReference = $definitionReference
}

$modifiedRD.artifacts += $buildArtifact

$modifiedRDJson= ($modifiedRD | ConvertTo-Json -Depth 20 -Compress)
Write-Output "modifiedRDJson: $modifiedRDJson"

$modifiedRDJson = Invoke-RestMethod -Uri $putRDUrl -headers $headers -ContentType 'application/json' -Method PUT -Body $modifiedRDJson
Write-Output "modifiedRDJson: $modifiedRDJson"

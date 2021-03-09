[CmdletBinding()]
param (
  [Parameter()]
  [string]
  $YamlVarsFile
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Trap
{
  Write-Error $_ -ErrorAction Continue
  exit 1
}


function CommandAliasFunction
{
  Write-Information ""
  Write-Information "$args"
  $cmd, $args = $args
  & "$cmd" $args
  if ($LASTEXITCODE)
  {
    throw "Exception Occured"
  }
  Write-Information ""
}

function JsonToVars
{
  [CmdletBinding()]
  param (
    [Parameter()]
    [String]
    $FileName
  )
  $obj = Get-Content $FileName | ConvertFrom-Json
  $obj | Get-Member -MemberType NoteProperty | ForEach-Object {
    Set-Variable -Name "$($_.Name)" -Value "$($obj."$($_.Name)")" -Scope global
  }
}

function YamlToVars
{
  [CmdletBinding()]
  param (
    [Parameter()]
    [String]
    $FileName
  )
  $obj = Get-Content $FileName | ConvertFrom-Yaml
  foreach ($h in $obj.GetEnumerator())
  {
    Set-Variable -Name "$($h.Name)" -Value "$($h.Value)" -Scope global
  }
}

Set-Alias -Name ce -Value CommandAliasFunction -Scope script

YamlToVars($YamlVarsFile)

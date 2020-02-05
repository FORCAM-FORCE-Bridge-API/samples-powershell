<#
.SYNOPSIS
Optain an  OAuth Access Token using the Client Credentials Flow

.DESCRIPTION
Before accessing the FORCE Bridge API an Access Token has to be requested.

.PARAMETER uriToBridgeApi
URI to Bridge API

.PARAMETER userName
Username for accessing the FORCAM Force Bridge API

.PARAMETER pword
Password 

.EXAMPLE
Get-OAuthToken

.EXAMPLE
Get-OAuthToken -userName 'GitHub' -pword 'GitHub'

.EXAMPLE
Get-OAuthToken -uriToBridgeApi 'https://virtualfactory.force.eco:24443/ffwebservices' -userName 'GitHub' -pword 'GitHub'

.NOTES

#>

function Get-OAuthToken {
	[CmdletBinding()]
	param (
		[Parameter()]
		[string]
		$uriToBridgeAPI = 'https://virtualfactory.force.eco:24443/ffwebservices',
		[string]
		$userName = 'GitHub',
		[string]
		$pword = 'GitHub'
	)

	$uriForTokenGeneration = $uriToBridgeAPI + "/oauth/token"

	$ErrorActionPreference = "Stop"

	$bytes = [System.Text.Encoding]::UTF8.GetBytes(
		('{0}:{1}' -f $userName, $pword)
	)

	$Authorization = "Basic {0}" -f ([Convert]::ToBase64String($bytes))
	$Headers = @{ 
		Accept        = "*/*"; 
		Authorization = $Authorization 
	}
	$Body = "grant_type=client_credentials&scope=read" # To gain write access: &scope=write%20read

	try {
		$response = Invoke-RestMethod -Uri $uriForTokenGeneration -Headers $Headers -Method Post -Body $Body
	}
	catch {
		Write-Error $_ -ErrorAction Stop
	}

	Write-Output $response.access_token

}
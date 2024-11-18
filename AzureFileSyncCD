<#
.DESCRIPTION
A Runbook example which continuously check for files and directories changes in recursive mode
For a specific Azure File Share in a specific Sync Group / Cloud Endpoint
Using the Managed Identity (Service Principal in Azure AD)

.NOTES
Filename : AzureFileSyncCD
Original Author: Charbel Nemnom (Microsoft MVP/MCT)
Author   : Mario Mancini
Version  : 2.0 
Date     : 03-August-2019 
Updated  : 03-May-2024 (managed identity)


#>
 
Param ( 
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] 
    [String] $AzureSubscriptionId, 
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
    [String] $ResourceGroupName, 
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
    [String] $StorageSyncServiceName, 
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
    [String] $SyncGroupName, 
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
    [String] $Path
) 

# Ensures you do not inherit an AzContext in your runbook 
Disable-AzContextAutosave -Scope Process 

# Connect to Azure with system-assigned managed identity (automation account) 
Connect-AzAccount -Identity 

# Set Azure Subscription context
Set-AzContext -SubscriptionId "$AzureSubscriptionId"

#! Get Cloud Endpoint Name
$azsync = Get-AzStorageSyncCloudEndpoint -ResourceGroupName "$ResourceGroupName" `
  -StorageSyncServiceName "$StorageSyncServiceName" -SyncGroupName "$SyncGroupName"

Write-Output "Get Azure Storage Sync Cloud Endpoint Name: $($azsync.CloudEndpointName)"

$cloudEndpoint = Get-AzStorageSyncCloudEndpoint -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName -SyncGroupName $StorageSyncServiceName
Write-Output "Get Azure Storage Sync Cloud Endpoint Name: $($cloudEndpoint)"

Invoke-AzStorageSyncChangeDetection -InputObject $cloudEndpoint -verbose

#! Invoke-AzStorageSyncChangeDetection
#Write-Output "Check for files and directories changes for $StorageSyncServiceName in $SyncGroupName" 
#Invoke-AzStorageSyncChangeDetection -ResourceGroupName "$ResourceGroupName" `
#  -StorageSyncServiceName "$StorageSyncServiceName" -SyncGroupName "$SyncGroupName" `
#  -CloudEndpointName "$($azsync.CloudEndpointName)" -DirectoryPath "$Path" -Recursive 

Write-Output ("Sync completata")

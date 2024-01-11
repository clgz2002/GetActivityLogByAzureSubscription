
function ListCreateEvents {
    param (
        [parameter(Mandatory=$true)]
        [string]$MySubscriptionName,

        [parameter(Mandatory=$true)]
        [datetime]$MyStartDate,

        [parameter(Mandatory=$true)]
        [datetime]$MyEndDate,

        [parameter(Mandatory=$true)]
        [string]$TypeOfEvent
    )

    Set-AzContext -SubscriptionName $MySubscriptionName

    # Set the start and end time for the logs (adjust the time range as needed)
    $startDate = $MyStartDate
    $endDate = $MyEndDate

    # Display the resource creation and deletion events    
    switch ($TypeOfEvent) {
        "create" {
            # Get the activity logs within the specified time range
            $activityLogs = Get-AzLog -StartTime $startDate -EndTime $endDate
            $resourceCreationLogs = $activityLogs | Where-Object { $_.OperationName -like "*create*" -and $_.Status -eq "Succeeded" }
            Write-Host  "Resource Create Events From:" $startDate " To:" $endDate
            $resourceCreationLogs | Format-Table -Property ResourceGroupName, ResourceProviderName, OperationName, Status, Category, SubmissionTimestamp, Caller -AutoSize
        }
        "delete" {
            # Get the activity logs within the specified time range
            $activityLogs = Get-AzLog -StartTime $startDate -EndTime $endDate
            $resourceDeletionLogs = $activityLogs | Where-Object { $_.OperationName -like "*delete*" -and $_.Status -eq "Succeeded" }
            Write-Host "Resource Deletion Events From:" $startDate " To:" $endDate
            $resourceDeletionLogs | Format-Table -Property ResourceGroupName, ResourceProviderName, OperationName, Status, Category, SubmissionTimestamp, Caller -AutoSize
        }
        default {
            Write-Host "You must use 'create' or 'delete' as TypeOfEvent parameter."
        }
    }
}

# Call the function
#ListCreateEvents -MySubscriptionName "InnovaMD-Development" -MyStartDate '2023-12-01' -MyEndDate '2023-12-31' -TypeOfEvent 'delete'

# Iterate over each element in the array and call the function
foreach ($Subscription in $MySubscriptions) {
    ListCreateEvents -MySubscriptionName $Subscription -MyStartDate '2023-12-01' -MyEndDate '2023-12-31' -TypeOfEvent 'delete'
}

# Creating an array of strings
$MySubscriptions = @("Azure Cosmos – Pyscope Test", 
                    "Business Intelligence", 
                    "Development", 
                    "ElevanceHealth",
                    "Enterprise Architects",
                    "Infra Lab",
                    "InnovaCareHealth-Dev",
                    "InnovaCareHealth-Prod",
                    "InnovaCareHealth-Test",
                    "InnovaMD-Beta",
                    "InnovaMD-Development",
                    "InnovaMD-DevOps",
                    "InnovaMD-Preprod",
                    "InnovaMD-Prod",
                    "MMM Virtual Desktops",
                    "MMM-DEVOPS",
                    "NonProd",
                    "Production",
                    "Quality",
                    "Shared Services",
                    "VitaCare_Subscription")

<#

# Get all subscriptions and filter out those containing "Visual" or "Microsoft", then sort by Name
$subscriptions = Get-AzSubscription | Where-Object { 
    $_.Name -notlike '*Visual*' -and $_.Name -notlike '*Microsoft*' 
} | Sort-Object -Property Name
# Display the filtered subscriptions
$subscriptions
$MySubscriptions

#>
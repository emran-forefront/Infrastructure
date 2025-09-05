targetScope = 'tenant'

param subscriptionName string
param billingScope string  // e.g. /providers/Microsoft.Billing/billingAccounts/{accountName}:...

resource sub 'Microsoft.Subscription/aliases@2020-09-01' = {
  name: uniqueString(subscriptionName)
  
  properties: {
    displayName: subscriptionName
    billingScope: billingScope
    workload: 'Production'
    scope: managementGroupResourceId('landingZonesMG', 'Microsoft.Management/managementGroups')
  }
}

output subscriptionId string = sub.properties.subscriptionId
output subscriptionName string = sub.properties.displayName

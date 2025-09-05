targetScope = 'resourceGroup'

param companyPrefix string
param location string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${companyPrefix}-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: '${companyPrefix}-alerts-ag'
  location: location
  properties: {
    groupShortName: 'alerts'
    enabled: true
    emailReceivers: [
      {
        name: 'OpsTeam'
        emailAddress: 'emran.hossain@forefront.se'
        useCommonAlertSchema: true
      }
    ]
  }
}

output logAnalyticsId string = logAnalytics.id

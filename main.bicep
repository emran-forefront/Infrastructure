targetScope = 'tenant'

@description('Resource Group name')
param rgName string = 'my-prod-rg'

@description('Resource Group location')
param rgLocation string = 'westeurope'


// Hub parameters
param hubVnetName string = 'hub-vnet'
param hubAddressPrefix string = '10.0.0.0/16'

// Spoke parameters
param spokeVnetName string = 'spoke-vnet'
param spokeAddressPrefix string = '10.1.0.0/16'

@description('Storage account name')
param storageAccountName string = 'mystorageacct001'

@description('Blob container name')
param containerName string = 'mycontainer'



resource landingZonesMG 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: '${companyPrefix}-landingzones'
}

module mg './modules/managementGroups.bicep' = {
  name: 'mg-deployment'
  params: {
    companyPrefix: companyPrefix
  }
}

module rgModule './modules/resourceGroup.bicep' = {
  name: 'deployRgModule'
  scope: subscription('SUBSCRIPTION_ID')
  params: {
    rgName: rgName
    rgLocation: rgLocation
    rgTags: {
      environment: 'prod'
      owner: 'IT'
    }
  }
}

output rgName string = rgModule.outputs.name

// Deploy Hub
module hub './modules/hubVnet.bicep' = {
  name: 'deployHubVnet'
  scope: resourceGroup(rgName, rgLocation)
  params: {
    vnetName: hubVnetName
    addressPrefix: hubAddressPrefix
    location: rgLocation
  }
}

module spoke './modules/spokeVnet.bicep' = {
  name: 'deploySpokeVnet'
  scope: resourceGroup(rgName, rgLocation)
  params: {
    vnetName: spokeVnetName
    addressPrefix: spokeAddressPrefix
    location: rgLocation
  }
}

module peering './modules/vnetPeering.bicep' = {
  name: 'deployVnetPeering'
  scope: resourceGroup(rgName, rgLocation)
  params: {
    peeringName: 'hubspoke'
    hubVnetId: hub.outputs.vnetId
    spokeVnetId: spoke.outputs.vnetId
    location: rgLocation
  }
}
  
module storageModule './modules/storageWithContainer.bicep' = {
  name: 'deployStorageWithContainer'
  scope: resourceGroup(rgName, rgLocation)
  params: {
    storageAccountName: storageAccountName
    location: rgLocation
    sku: 'Standard_LRS'
    kind: 'StorageV2'
    containerName: containerName
    containerAccessLevel: 'Private'
    tags: {
      environment: 'prod'
      owner: 'IT'
    }
  }
}

output storageAccountName string = storageModule.outputs.storageAccountName
output storageAccountId string = storageModule.outputs.storageAccountId
output containerName string = storageModule.outputs.containerName


@description('Prefix for company resources')
param companyPrefix string = 'mycompany'

module monitoring './modules/monitoring.bicep' = {
  name: 'monitoring-deployment'
  scope: resourceGroup('rg-monitoring', 'East US')
  params: {
    companyPrefix: companyPrefix
    location: 'East US'
  }
}


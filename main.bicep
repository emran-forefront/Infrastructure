targetScope = 'subscription'

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

module rgModule './modules/resourceGroup.bicep' = {
  name: 'deployRgModule'
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
  scope: resourceGroup(rgName)
  params: {
    vnetName: hubVnetName
    addressPrefix: hubAddressPrefix
    location: rgLocation
  }
}

module spoke './modules/spokeVnet.bicep' = {
  name: 'deploySpokeVnet'
  scope: resourceGroup(rgName)
  params: {
    vnetName: spokeVnetName
    addressPrefix: spokeAddressPrefix
    location: rgLocation
  }
}

module peering './modules/vnetPeering.bicep' = {
  name: 'deployVnetPeering'
  scope: resourceGroup(rgName)
  params: {
    peeringName: 'hubspoke'
    hubVnetId: hub.outputs.vnetId
    spokeVnetId: spoke.outputs.vnetId
    location: rgLocation
  }
}
  
module storageModule './modules/storageWithContainer.bicep' = {
  name: 'deployStorageWithContainer'
  scope: resourceGroup(rgName)
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


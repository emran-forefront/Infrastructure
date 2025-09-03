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
  



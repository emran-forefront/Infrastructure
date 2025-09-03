targetScope = 'resourceGroup'

@description('Name of the peering')
param peeringName string

@description('Hub VNet ID')
param hubVnetId string

@description('Spoke VNet ID')
param spokeVnetId string

@description('Location')
param location string

resource hubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: '${split(hubVnetId, '/')[8]}/${peeringName}-hub-to-spoke'
  location: location
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnetId
    }
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
  }
}

resource spokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: '${split(spokeVnetId, '/')[8]}/${peeringName}-spoke-to-hub'
  location: location
  properties: {
    remoteVirtualNetwork: {
      id: hubVnetId
    }
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
  }
}

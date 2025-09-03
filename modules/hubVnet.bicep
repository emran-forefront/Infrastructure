targetScope = 'resourceGroup'

@description('Hub VNet name')
param vnetName string

@description('Hub VNet address space')
param addressPrefix string

@description('Location of the VNet')
param location string

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

output vnetId string = hubVnet.id

targetScope = 'resourceGroup'

@description('Spoke VNet name')
param vnetName string

@description('Spoke VNet address space')
param addressPrefix string

@description('Location of the VNet')
param location string

resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
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
        name: 'default'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]
  }
}

output vnetId string = spokeVnet.id

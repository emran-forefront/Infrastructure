targetScope = 'subscription'

@description('Resource Group name')
param rgName string = 'my-prod-rg'

@description('Resource Group location')
param rgLocation string = 'westeurope'

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

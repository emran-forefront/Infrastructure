targetScope = 'subscription'

@description('Name of the Resource Group')
param rgName string

@description('Location of the Resource Group')
param rgLocation string

@description('Tags for the Resource Group')
param rgTags object = {}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
  tags: rgTags
}

output name string = rg.name

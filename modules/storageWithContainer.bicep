targetScope = 'resourceGroup'

@description('Globally unique storage account name (3–24 lowercase letters and numbers)')
param storageAccountName string

@description('Azure region')
param location string

@description('Storage SKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param sku string = 'Standard_LRS'

@description('Storage kind')
@allowed([
  'StorageV2'
  'BlobStorage'
])
param kind string = 'StorageV2'

@description('Blob container name')
param containerName string

@description('Access level for the blob container')
@allowed([
  'Private'
  'Blob'
  'Container'
])
param containerAccessLevel string = 'Private'

@description('Optional tags')
param tags object = {}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
  tags: tags
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storage.name}/default/${containerName}'
  properties: {
    publicAccess: containerAccessLevel
  }
}

output storageAccountId string = storage.id
output storageAccountName string = storage.name
output containerName string = container.name

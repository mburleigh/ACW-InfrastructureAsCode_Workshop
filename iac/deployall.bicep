targetScope = 'subscription'  // multiple resource groups in the same subscription

param rgName string = 'iac-workshop-bccode-2'
param location string = 'eastus'
param storageAccountName string = 'mystorage'
param uniqueIdentifier string = '20200802mfb'
param environment string = 'dev'
param containerName string

resource storageResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: location
}

module storageAccount 'storageAccount.bicep' = {
  name: 'storageAccountModule'
  scope: storageResourceGroup
  params: {
    storageAccountName: storageAccountName
    location: location
    uniqueIdentifier: uniqueIdentifier
    environment: environment
  }
}

module storageAccountContainer 'storageAccountContainer.bicep' = {
  name: 'storageAccountContainer-${containerName}'
  scope: storageResourceGroup
  params: {
    storageAccountFullName: storageAccount.outputs.storageAccountName
    containerName: containerName
  }
  //dependsOn: [
  //  // grandparents
  //]
}

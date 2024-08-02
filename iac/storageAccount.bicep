//param location string = 'eastus'
//@allowed([
//  'eastus'
//  'westus'
//])
//param location string
param location string = resourceGroup().location

//param storageAccountName string = 'mystorage20200802mfb'
@minLength(3)
param storageAccountName string
//subscription().subscriptionId => GUID of subscription (similar for tenant)

@minLength(11)
@maxLength(11)
param uniqueIdentifier string

@allowed([
  'dev'
  'tst'
  'uat'
  'prd'
])
param environment string = 'dev'

//var uniqueStringVariable = uniqueString(resourceGroup().id)
//var storageAccountNameFull = '${storageAccountName}${uniqueIdentifier}${environment}'

// because of storage account name length limit; will fail if account name length < 24 to begin
var storageAccountNameFull = substring('${storageAccountName}${uniqueIdentifier}${environment}${uniqueString(resourceGroup().id)}', 0, 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  //name: storageAccountName
  name: storageAccountNameFull
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output storageAccountNLocation string = storageAccount.location


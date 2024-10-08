param storageAccountName string
param queueName string
param location string = resourceGroup().location
var storageAccountSku = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: storageAccountSku }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
  }

  resource queueServices 'queueServices' = {
    name: 'default'
    resource storageQueueMain 'queues' = {
      name: queueName
    }    
  }
}


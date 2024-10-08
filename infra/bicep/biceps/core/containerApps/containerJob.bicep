param location string = resourceGroup().location
param jobName string
param acrName string
param containerImageName string
param storageAccountName string
param queueName string
param environmentName string
param queueConnectionString string

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

resource jobs 'Microsoft.App/jobs@2024-03-01' = {
  name: jobName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    environmentId: resourceId('Microsoft.App/managedEnvironments', environmentName)
    configuration: {
      triggerType: 'Event'
      replicaTimeout: 1800
      replicaRetryLimit: 0
      eventTriggerConfig: {
        parallelism: 1
        replicaCompletionCount: 1
        scale: {
          maxExecutions: 10
          minExecutions: 0
          pollingInterval: 60
          rules: [
            {
              name: 'queue'
              type: 'azure-queue'

              metadata: {
                accountName: storageAccountName
                queueName: queueName
                queueLength: '1'
              }
              auth: [
                {
                  secretRef: 'connection-string-secret'
                  triggerParameter: 'connection'
                }
              ]
            }
          ]
        }
      }
      registries: [
        {
          server: '${acrName}.azurecr.io'
          passwordSecretRef: '${acrName}azurecrio-password'
          username: acrName
        }
      ]
      secrets: [
        {
          name: 'connection-string-secret'
          value: queueConnectionString
        }
        {
          name: '${acrName}azurecrio-password'
          value: acrResource.listCredentials().passwords[0].value
        }
      ]
    }

    template: {
      containers: [
        {
          name: jobName
          image: '${acrName}.azurecr.io/${containerImageName}'
          args: []
          command: []
          env: [
            {
              name: 'AZURE_STORAGE_QUEUE_NAME'
              value: queueName
            }
            {
              name: 'AZURE_STORAGE_CONNECTION_STRING'
              secretRef: 'connection-string-secret'
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}
var queueRoleDefinitionId= '974c5e8b-45b9-4653-ba55-5f855dd0fb88' // ストレージ キュー データ共同作成者
var principalId = jobs.identity.principalId
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, queueRoleDefinitionId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', queueRoleDefinitionId)
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

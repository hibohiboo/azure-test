param location string = resourceGroup().location
param jobName string
param acrName string
param containerImageName string
param storageAccountName string
param queueName string
param environmentName string
@secure()
param queueConnectionString string

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
      eventTriggerConfig: {
        parallelism: 1
        replicaCompletionCount: 1
        scale: {
          maxExecutions: 10
          minExecutions: 0
          pollingInterval: 60
          rules: [
            {
              auth: [
                {
                  secretRef: 'connection-string-secret'
                  triggerParameter: 'connection'
                }
              ]
              metadata: {
                accountName: storageAccountName
                queueName: queueName
                queueLength: 1
              }
              name: 'queue'
              type: 'azure-queue'
            }
          ]
        }
      }
      registries: [
        {
          server: '${acrName}.azurecr.io'
          // passwordSecretRef: 'string'
          // username: 'string'
        }
      ]
      replicaRetryLimit: 3
      replicaTimeout: 1800
      secrets: [
        {
          name: 'connection-string-secret'
          value: queueConnectionString
        }
      ]
    }

    template: {
      containers: [
        {
          name: jobName
          image: '${acrName}.azurecr.io/${containerImageName}'
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
            cpu: any('0.5')
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

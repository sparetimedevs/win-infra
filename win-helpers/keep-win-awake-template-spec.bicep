param keepWinAwakeServiceName string = 'keep-win-awake'
param winApimBaseUrl string = 'override-with-a-base-url'
param winOcpApimSubscriptionKey string = 'override-with-a-key'

resource keepWinAwakeServiceName_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: keepWinAwakeServiceName
  location: 'westeurope'
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {
              do: 'it'
            }
          }
        }
      }
      actions: {
        Initialize_variable: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'counter'
                type: 'integer'
                value: 0
              }
            ]
          }
        }
        Until: {
          actions: {
            Delay: {
              runAfter: {
                HTTP: [
                  'Succeeded'
                ]
              }
              type: 'Wait'
              inputs: {
                interval: {
                  count: 14
                  unit: 'Minute'
                }
              }
            }
            HTTP: {
              runAfter: {}
              type: 'Http'
              inputs: {
                headers: {
                  'Api-Version': 'v1'
                  Host: 'sparetimedevs.azure-api.net'
                  'Ocp-Apim-Subscription-Key': winOcpApimSubscriptionKey
                  'Ocp-Apim-Trace': 'true'
                }
                method: 'GET'
                uri: '${winApimBaseUrl}/win/candidates'
              }
            }
            Increment_variable: {
              runAfter: {
                Delay: [
                  'Succeeded'
                ]
              }
              type: 'IncrementVariable'
              inputs: {
                name: 'counter'
              }
            }
          }
          runAfter: {
            Initialize_variable: [
              'Succeeded'
            ]
          }
          expression: '@greaterOrEquals(variables(\'counter\'), 7)'
          limit: {
            count: 10
            timeout: 'PT1H'
          }
          type: 'Until'
        }
      }
      outputs: {}
    }
  }
}
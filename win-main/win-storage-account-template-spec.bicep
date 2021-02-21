param winStorageAccountName string = 'winstorageaccount'

resource winStorageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: winStorageAccountName
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'Storage'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: false
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource winStorageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  name: '${winStorageAccountName_resource.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_winStorageAccountName_default 'Microsoft.Storage/storageAccounts/fileServices@2019-06-01' = {
  name: '${winStorageAccountName_resource.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource winStorageAccountName_default_azure_pipelines_deploy 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${winStorageAccountName_default.name}/azure-pipelines-deploy'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    winStorageAccountName_resource
  ]
}

resource winStorageAccountName_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${winStorageAccountName_default.name}/azure-webjobs-hosts'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    winStorageAccountName_resource
  ]
}

resource winStorageAccountName_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${winStorageAccountName_default.name}/azure-webjobs-secrets'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    winStorageAccountName_resource
  ]
}

resource winStorageAccountName_default_winStorageAccountName_winb6d9 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${Microsoft_Storage_storageAccounts_fileServices_winStorageAccountName_default.name}/${winStorageAccountName}-winb6d9'
  properties: {
    shareQuota: 5120
  }
  dependsOn: [
    winStorageAccountName_resource
  ]
}

output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${winStorageAccountName};AccountKey=${listKeys(winStorageAccountName_resource.id, '2019-06-01').keys[0].value}'
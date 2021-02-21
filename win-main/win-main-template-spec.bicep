param winStorageAccountNameMain string = 'winstorageaccount'
param winApimNameMain string = 'win-apim'
param winApimPublisherEmailMain string = 'replace@this.com'
param winFunctionAppNameMain string = 'win-function-app'
param mongoDbConnectionStringMain string = 'override-with-a-mongo-db-connection-string'

module winStorageAccountDeployment './win-storage-account-template-spec.bicep' = {
  name: 'winStorageAccountDeployment'
  params:{
    winStorageAccountName: winStorageAccountNameMain
  }
}

module winApimServiceDeployment './win-apim-service-template-spec.bicep' = {
  name: 'winApimServiceDeployment'
  params:{
    winApimName: winApimNameMain
    winApimPublisherEmail: winApimPublisherEmailMain    
  }
}

module winFunctionAppServiceDeployment './win-function-app-service-template-spec.bicep' = {
  name: 'winFunctionAppServiceDeployment'
  params:{
    winFunctionAppName: winFunctionAppNameMain
    storageAccountConnectionString: winStorageAccountDeployment.outputs.storageAccountConnectionString
    mongoDbConnectionString: mongoDbConnectionStringMain 
  }
}
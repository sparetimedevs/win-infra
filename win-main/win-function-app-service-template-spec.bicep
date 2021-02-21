param winFunctionAppName string = 'win-function-app'
param serverFarmsPlanName string = 'function-app-plan'
param storageAccountConnectionString string = 'override-with-a-storage-account-connection-string'
param mongoDbConnectionString string = 'override-with-a-mongo-db-connection-string'

resource serverFarmsPlanName_resource 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: serverFarmsPlanName
  location: 'West Europe'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource winFunctionAppName_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: winFunctionAppName
  location: 'West Europe'
  kind: 'functionapp'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${winFunctionAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${winFunctionAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverFarmsPlanName_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'java'
        }
        {
          name: 'MONGO_DB_CONNECTION_STRING'
          value: mongoDbConnectionString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(winFunctionAppName)
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

resource winFunctionAppName_web 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${winFunctionAppName_resource.name}/web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2017'
    httpLoggingEnabled: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$sparetimedevs-win'
    scmType: 'VSTSRM'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    javaVersion: '1.8'
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    cors: {
      allowedOrigins: [
        'https://functions.azure.com'
        'https://functions-staging.azure.com'
        'https://functions-next.azure.com'
      ]
      supportCredentials: false
    }
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    ftpsState: 'Disabled'
    reservedInstanceCount: 0
  }
}

resource winFunctionAppName_winFunctionAppName_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2018-11-01' = {
  name: '${winFunctionAppName_resource.name}/${winFunctionAppName}.azurewebsites.net'
  properties: {
    siteName: 'sparetimedevs-win'
    hostNameType: 'Verified'
  }
}
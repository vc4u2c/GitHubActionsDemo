param pLocation string
param pApplicationName string
param pEnv string

// App Service Plan
param pAppServicePlanName string = 'pl-${pApplicationName}-${pEnv}-${pLocation}'
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: pAppServicePlanName
  kind: 'linux'
  properties: {
    reserved: true
  }
  location: pLocation
  sku: {
    name: 'S1'
    capacity: 1
  }
}

// App Service
param pAppServiceName string = 'app-${pApplicationName}-${pEnv}'
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: pAppServiceName
  location: pLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', pAppServicePlanName)
  }
  dependsOn: [
    appServicePlan
  ]
}

// Application Settings for App Service
resource appServiceAppSetting 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'web'
  parent: appService
  properties: {
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: appInsights.properties.InstrumentationKey
      }
    ]
  }
}

// App Insights
param pAppInsightsName string = 'log-${pApplicationName}-${pEnv}'
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: pAppInsightsName
  location: pLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output oAppServiceName string = pAppServiceName

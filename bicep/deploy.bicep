@description('Location of all the resources')
param pLocation string = resourceGroup().location
param pApplicationName string
param pEnv string

module appServiceModule 'deploy-app-service.bicep' = {
  name: 'appServiceModule'
  params: {
    pEnv: pEnv
    pLocation: pLocation
    pApplicationName: pApplicationName
  }
}

output oAppServiceName string = appServiceModule.outputs.oAppServiceName

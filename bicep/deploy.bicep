param pStorageAccountForDiagnosticsName string = 'stredisdiagnostics'
param pApplicationName string = 'azurecacheforredisdemo'
@description('Specify the name of the Azure Redis Cache to create.')
param pRedisCacheName string = 'redis-${pApplicationName}'
param pEnv string = 'dev'

@description('Location of all resources')
param pLocation string = resourceGroup().location

@description('Specify the pricing tier of the new Azure Redis Cache.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param pRedisCacheSku string = 'Basic'

@description('Specify the family for the sku. C = Basic/Standard, P = Premium.')
@allowed([
  'C'
  'P'
])
param pRedisCacheFamily string = 'C'

@description('Specify the size of the new Azure Redis Cache instance. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4)')
@allowed([
  0
  1
  2
  3
  4
  5
  6
])
param pRedisCacheCapacity int = 1

@description('Specify a boolean value that indicates whether to allow access via non-SSL ports.')
param pEnableNonSslPort bool = false

@description('Specify a boolean value that indicates whether diagnostics should be saved to the specified storage account.')
param pDiagnosticsEnabled bool = false

module storageAccountForDiagnosticsModule 'deploy-storage.bicep' = {
  name: 'storageAccountForDiagnosticsModule'
  params: {
    pName: pStorageAccountForDiagnosticsName
    pLocation: pLocation
  }
}

module redisCacheModule 'deploy-redis.bicep' = {
  name: 'redisCacheModule'
  params: {
    pLocation: pLocation
    pRedisCacheName: pRedisCacheName
    pRedisCacheFamily: pRedisCacheFamily
    pRedisCacheCapacity: pRedisCacheCapacity
    pRedisCacheSku: pRedisCacheSku
    pDiagnosticsEnabled: pDiagnosticsEnabled
    pEnableNonSslPort: pEnableNonSslPort
    existingDiagnosticsStorageAccountResourceGroup: resourceGroup().name
    pExistingDiagnosticsStorageAccountName: pStorageAccountForDiagnosticsName
  }
}

module appServiceModule 'deploy-app-service.bicep' = {
  name: 'appServiceModule'
  params: {
    pEnv: pEnv
    pLocation: pLocation
    pApplicationName: pApplicationName
    pRedisCacheName: pRedisCacheName
  }
}

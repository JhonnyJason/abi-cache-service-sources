accessmodule = {name: "accessmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["accessmodule"]?  then console.log "[accessmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
secretManagerClientFactory = require("secret-manager-client")

############################################################
state = null

#endregion

############################################################
#region internalProperties
secretManagerData = null
secretManagerClient = null

# authCode = "..."
# etherscanAccessToken = "..."

#endregion

############################################################
#region exposedProperties
accessmodule.authCode = ""
accessmodule.etherscanAccessToken = ""

#endregion

############################################################
accessmodule.initialize = ->
    log "accessmodule.initialize"
    state = allModules.persistentstatemodule
    
    secretManagerData = state.load("secretManagerData")
    url = secretManagerData.serverURL
    secretKey = secretManagerData.secretKeyHex
    publicKey = secretManagerData.publicKeyHex
    
    secretManagerClient = await secretManagerClientFactory.createClient(secretKey, publicKey, url)
    
    secretManagerData.serverURL = secretManagerClient.serverURL
    secretManagerData.secretKeyHex = secretManagerClient.secretKeyHex
    secretManagerData.publicKeyHex = secretManagerClient.publicKeyHex
    state.save("secretManagerData", secretManagerData)
    
    # olog secretManagerData
    return


############################################################
accessmodule.retrieveAccessSecrets = ->
    ## to set the defaults when we did not set up any secrets yet...
    # try secretAuthCode = await secretManagerClient.getSecret("authCode")
    # catch err then await secretManagerClient.setSecret("authCode", authCode)
    # try secretEtherscanAccessToken = await secretManagerClient.getSecret("etherscanAccessToken")
    # catch err then await secretManagerClient.setSecret("etherscanAccessToken", etherscanAccessToken)
    
    accessmodule.authCode = await secretManagerClient.getSecret("authCode")
    accessmodule.etherscanAccessToken = await secretManagerClient.getSecret("etherscanAccessToken")
    # olog accessmodule
    return

    
module.exports = accessmodule
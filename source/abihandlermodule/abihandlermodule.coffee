abihandlermodule = {name: "abihandlermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["abihandlermodule"]?  then console.log "[abihandlermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
abiStore = null
network = null
access = null

#endregion

############################################################
abihandlermodule.initialize = () ->
    log "abihandlermodule.initialize"
    network = allModules.networkmodule
    access = allModules.accessmodule
    abiStore = allModules.abistoremodule
    return
    
############################################################
abihandlermodule.getABI = (address) ->
    abi = abiStore.getABI(address)
    if abi? then return {"jsonABI":abi}

    abi = await network.getABI(address)
    abiStore.addABI(address, abi)
    return {"jsonABI":abi}

module.exports = abihandlermodule
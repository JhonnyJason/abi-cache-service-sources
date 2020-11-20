abistoremodule = {name: "abistoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["abistoremodule"]?  then console.log "[abistoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null

############################################################
#region internalProperties
addressToABIMap = {}
cachedAddresses = []
maxCacheSize = 0

#endregion

############################################################
abistoremodule.initialize = ->
    log "abistoremodule.initialize"
    state = allModules.persistentstatemodule
    c = allModules.configmodule
    maxCacheSize = c.numberOfChachedEntries

    addressToABIMap = state.load("addressToABIMap")
    assertCleanCachedState()
    # printState()
    return

############################################################
#region internalFunctions
printState = ->
    log "printState"
    olog addressToABIMap
    olog cachedAddresses
    log " - - - "
    return

############################################################
#region caching helpers
assertCleanCachedState = ->
    allAddresses = Object.keys(addressToABIMap)
    if cachedAddresses.length == 0
        for address in allAddresses
            if cachedAddresses.length == maxCacheSize
                if addressToABIMap[address] != 1 then removeFromCache(address)
            else if addressToABIMap[address] != 1
                cachedAddresses.push(address)
                state.save(address, addressToABIMap[address])
    ## else TODO or maybe not relevant if it is only used on initialize        
    saveState()
    return

assertAddressIsAvailable = (address) ->
    throw new Error("No address provided!") unless address
    throw new Error("Unknown address!") unless addressToABIMap[address]?
    if addressToABIMap[address] == 1 then loadIntoCache(address)
    return

addNewEntry = (address, abi) ->
    log "addNewEntry: "+address
    addressToABIMap[address] = abi
    state.save(address, addressToABIMap[address])
    cachedAddresses.push(address)
    cacheRemoveExcess()
    # printState()
    return

loadIntoCache = (address) ->
    log "loadIntoCache: "+address
    return unless addressToABIMap[address]?
    index = cachedAddresses.indexOf(address)
    if index > 0 then cachedAddresses.splice(index, 1)
    addressToABIMap[address] = state.load(address)
    cachedAddresses.push(address)
    cacheRemoveExcess()
    # printState()
    return

removeFromCache = (address) ->
    log "removeFromCache: "+address
    if !addressToABIMap[address]? then throw new Error("Address to removeFromCache does not exist!")
    state.save(address, addressToABIMap[address])
    state.uncache(address)
    addressToABIMap[address] = 1
    return

cacheRemoveExcess = ->
    excess = cachedAddresses.length - maxCacheSize
    return if excess <= 0
    while excess--
        address = cachedAddresses.shift()
        removeFromCache(address)
    return

saveState = ->
    try state.save("addressToABIMap", addressToABIMap)
    catch err then processUnexpected err
    return

#endregion

#endregion

############################################################
#region exposedFunctions
abistoremodule.addABI = (address, abi) ->
    addNewEntry(address, abi)
    saveState()
    return

abistoremodule.getABI = (address, abi) ->
    try assertAddressIsAvailable(address)
    catch err then return null
    return addressToABIMap[address]

#endregion

module.exports = abistoremodule
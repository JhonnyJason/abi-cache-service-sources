
startupmodule = {name: "startupmodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["startupmodule"]?  then console.log "[startupmodule]: " + arg
    return

############################################################
import sci from "./scimodule"
access = require("./accessmodule")

############################################################
startupmodule.initialize = () ->
    log "startupmodule.initialize"
    return

############################################################
startupmodule.serviceStartup = ->
    log "startupmodule.serviceStartup"
    await access.retrieveAccessSecrets()
    sci.prepareAndExpose()
    return

export default startupmodule
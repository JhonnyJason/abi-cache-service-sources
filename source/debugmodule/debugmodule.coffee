debugmodule = {name: "debugmodule"}

############################################################
debugmodule.initialize = () ->
    #console.log "debugmodule.initialize - nothing to do"
    return

############################################################
debugmodule.modulesToDebug = 
    unbreaker: true
    # configmodule: true
    # abihandlermodule: true
    # abistoremodule: true
    # accessmodule: true
    # startupmodule: true

#region exposed variables

export default debugmodule
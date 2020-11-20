
scihandlers = {name: "scihandlers"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scihandlers"]?  then console.log "[scihandlers]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
abiHandler = require("./abihandlermodule")
access = require("./accessmodule")

############################################################
scihandlers.authenticate = (req, res, next) ->
    try
        if req.body.authCode == access.authCode then next()
        else throw new Error("Wrong Auth Code!")
    catch err then res.send({error: err.stack})
    return

############################################################
#region handlerFunctions
scihandlers.getABI = (authCode, address) ->
    result = await abiHandler.getABI(address)
    return result

#endregion

#endregion exposed functions

export default scihandlers

sciroutes = {}

############################################################
import h from "./scihandlers"

############################################################
#region routes

sciroutes.getABI = (req, res) ->
    try
        response = await h.getABI(
            req.body.authCode,
            req.body.address
        )
        res.send(response)
    catch err then res.send({error: err.stack})
    return

#endregion

export default sciroutes

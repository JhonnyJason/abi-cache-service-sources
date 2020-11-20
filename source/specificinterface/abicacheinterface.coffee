abicacheinterface = {}

ABIRequest = "https://api.etherscan.io/api?module=contract&action=getabi&address="


############################################################
#region checkResponse
digestABIResponse = (response) ->
    digest = JSON.parse(response.result)
    return digest

getKeyPart = ->
    token = allModules.accessmodule.etherscanAccessToken
    return "&apikey="+token
#endregion

############################################################
abicacheinterface.getABI = (address) ->
    keyPart = getKeyPart()
    url = ABIRequest+address+keyPart
    response = await @getData(url)
    digested = digestABIResponse(response)
    return digested

#endregion

    
module.exports = abicacheinterface

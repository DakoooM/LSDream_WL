LSDream.getPlayersData = function()
    return LSDream.Player
end

LSDream.getPlayersById = function(id)
    if type(id) ~= "number" then return error("Please enter number in arg (getPlayersById)") end
    return LSDream.Player[tostring(id)]
end

LSDream.getPlayers = function()
    return LSDream.allSourcePlayers
end
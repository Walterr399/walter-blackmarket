ESX = exports["es_extended"]:getSharedObject()

local Shared = require("shared.shared")

RegisterNetEvent("walter-blackmarket:server:purchase", function(itemName, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        vx.print.error("Cannot fetch player")
        return
    end

    local data
    for _, category in pairs(Shared.Config.BlackmarketItems) do
        for _, item in ipairs(category) do
            if item.name == itemName then
                data = item
                break
            end
        end
        if data then break end
    end

    local amount = data.amount or 1

    if xPlayer.getAccount("bank").money >= price then
        xPlayer.removeAccountMoney("bank", price)
        exports.ox_inventory:AddItem(src, itemName, amount)

        vx.notify(src, {
            title = "Blackmarket",
            message = ("Je hebt %sx %s gekocht voor €%s"):format(amount, data.title, price),
            type = "success"
        })
    else
        vx.notify(src, {
            title = "Blackmarket",
            message = "Je hebt niet genoeg geld",
            type = "error"
        })
    end
end)

vx.callback.register("walter-blackmarket:server:receive:config", function'()
    return Shared
end)
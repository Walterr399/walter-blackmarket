ESX = exports["es_extended"]:getSharedObject()

if Shared.Debug then
    if not ESX then
        vx.print.debug("failed to load ESX")
        return
    end
end

-- [[ IMPORTS ]] --
local Shared = require("shared.shared")

-- [[ EVENTS ]] --
RegisterNetEvent("walter-blackmarket:server:purchase", function(itemName, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        if Shared.Debug then
            vx.print.error("Cannot fetch player")
        end
        return
    end

    local data
    for _, category in pairs(Shared.Config) do
        for _, item in ipairs(category) do
            if item.name == itemName then
                data = item
                break
            end
        end
        if data then break end
    end

    if not data then
        vx.print.error("Item not found: " .. tostring(itemName))
        return
    end

    local amount = data.amount or 1

    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount("bank").money

    if cash >= price then
        xPlayer.removeMoney(price)
        exports.ox_inventory:AddItem(src, itemName, amount)

        vx.notify(src, {
            title = "Blackmarket",
            message = ("Je hebt %sx %s gekocht voor €%s (contant)"):format(amount, data.title, price),
            type = "success"
        })
    elseif bank >= price then
        xPlayer.removeAccountMoney("bank", price)
        exports.ox_inventory:AddItem(src, itemName, amount)

        vx.notify(src, {
            title = "Blackmarket",
            message = ("Je hebt %sx %s gekocht voor €%s (bank)"):format(amount, data.title, price),
            type = "success"
        })
    else
        vx.notify(src, {
            title = "Blackmarket",
            message = "Je hebt niet genoeg geld (contant of op bank).",
            type = "error"
        })
    end
end)


-- [[ CALLBACKS ]] --
vx.callback.register("walter-blackmarket:server:receive:config", function()
    return Shared
end)
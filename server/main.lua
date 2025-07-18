ESX = exports["es_extended"]:getSharedObject()

-- [[ IMPORTS ]] --
local Shared = "shared"

if Shared.Debug then
    if not ESX then
        vx.print.debug("[DEBUG] Failed to load ESX")
        return
    else
        vx.print.debug("[DEBUG] ESX successfully loaded")
    end
end

-- [[ EVENTS ]] --
RegisterNetEvent("walter-blackmarket:server:purchase", function(itemName, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if Shared.Debug then
        vx.print.debug(("[DEBUG] Processing purchase: src=%s, itemName=%s, price=%s"):format(src, tostring(itemName), tostring(price)))
    end

    if not xPlayer then
        if Shared.Debug then
            vx.print.error("[ERROR] Cannot fetch player for src: " .. tostring(src))
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
        vx.print.error("[ERROR] Item not found: " .. tostring(itemName))
        return
    end

    local amount = data.amount or 1

    if Shared.Debug then
        vx.print.debug(("[DEBUG] Found item config: %s | Title: %s | Amount: %s"):format(data.name, data.title or "N/A", amount))
    end

    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount("bank").money

    if Shared.Debug then
        vx.print.debug(("[DEBUG] Player funds - Cash: €%s | Bank: €%s"):format(cash, bank))
    end

    if cash >= price then
        xPlayer.removeMoney(price)
        exports.ox_inventory:AddItem(src, itemName, amount)

        if Shared.Debug then
            vx.print.debug(("[DEBUG] Purchase successful using cash: %s x %s for €%s"):format(amount, itemName, price))
        end

        vx.notify(src, {
            title = "Blackmarket",
            message = ("Je hebt %sx %s gekocht voor €%s (contant)"):format(amount, data.title, price),
            type = "success"
        })
    elseif bank >= price then
        xPlayer.removeAccountMoney("bank", price)
        exports.ox_inventory:AddItem(src, itemName, amount)

        if Shared.Debug then
            vx.print.debug(("[DEBUG] Purchase successful using bank: %s x %s for €%s"):format(amount, itemName, price))
        end

        vx.notify(src, {
            title = "Blackmarket",
            message = ("Je hebt %sx %s gekocht voor €%s (bank)"):format(amount, data.title, price),
            type = "success"
        })
    else
        if Shared.Debug then
            vx.print.debug("[DEBUG] Purchase failed - insufficient funds.")
        end

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

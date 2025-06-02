ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("walter-blackmarket:server:purchase", function(itemName, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        vx.print.error("Cannot fetch player")
        return
    end

    local itemData
    for _, category in pairs(Shared.Config.BlackmarketItems) do
        for _, item in ipairs(category) do
            if item.name == itemName then
                itemData = item
                break
            end
        end
        if itemData then break end
    end

    if not itemData then
        vx.print.error("Item not found in config: " .. tostring(itemName))
        return
    end

    local amount = itemData.amount or 1

    if xPlayer.getAccount("bank").money >= price then
        xPlayer.removeAccountMoney("bank", price)
        exports.ox_inventory:AddItem(src, itemName, amount)

        vx.notify(src, {
            title = "Blackmarket",
            message = ("Je hebt %sx %s gekocht voor €%s"):format(amount, itemData.title, price),
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
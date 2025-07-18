local Shared = vx.callback.await("walter-blackmarket:server:receive:config")

local point = lib.points.new({
    coords = Shared.Location,
    distance = 2.5,
})

function point:onEnter()
    vx.showTextUi("[E] - Open Blackmarket")
end

function point:onExit()
    vx.hideTextUi()
end

function point:nearby()
    DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)

    if self.currentDistance < 2.5 and vx.IsControlJustReleased("E") then
        openBlackmarket()
    end
end

function formatPrice(price)
    local formatted = tostring(price)
    local k
    while true do  
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then break end
    end
    return formatted
end

function openBlackmarket()
    lib.registerContext({
        id = 'blackmarket_menu',
        title = 'Blackmarket',
        options = {
            {
                title = 'Wapens',
                description = 'Bekijk wapens',
                icon = 'gun',
                onSelect = function()
                    openShop("weapons")
                end
            },
            {
                title = "Ammo",
                description = "Bekijk ammunitie",
                icon = "box",
                onSelect = function()
                    openShop("ammo")
                end
            },
            {
                title = "Drugs",
                description = "Bekijk drugs",
                icon = 'cannabis',
                onSelect = function()
                    openShop("drugs")
                end
            }
        }
    })
    lib.showContext("blackmarket_menu")
end

function openShop(category)
    local items = Shared.Config[category]
    local options = {}

    for _, item in ipairs(items) do
        table.insert(options, {
            title = item.title .. " - €" .. formatPrice(item.price),
            icon = item.icon,
            onSelect = function()
                vx.TriggerServerEvent("walter-blackmarket:server:purchase", item.name, item.price)
            end
        })
    end

    lib.registerContext({
        id = 'shop_menu',
        title = "Wapendealer",
        options = options
    })

    lib.showContext("shop_menu")
end

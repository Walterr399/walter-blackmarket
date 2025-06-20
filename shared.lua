Shared = {}

Shared.Location = vector3(0.0, 0.0, 0.0) --# Replace with actual coords

Shared.Config = {
    weapons = {
        { title = "Pistol", name = "weapon_pistol", price = 1500, icon = "gun" },
        { title = "SMG", name = "weapon_smg", price = 3500, icon = "gun" },
        { title = "Knife", name = "weapon_knife", price = 500, icon = "knife" }
    },
    ammo = {
        { title = "Pistol Ammo", name = "pistol_ammo", price = 200, icon = "box", amount = 25 },
        { title = "SMG Ammo", name = "smg_ammo", price = 300, icon = "box", amount = 30 }
    },
    drugs = {
        { title = "Weed", name = "weed_bag", price = 100, icon = "cannabis" },
        { title = "Cocaine", name = "coke_bag", price = 500, icon = "flask" },
        { title = "Meth", name = "meth_bag", price = 600, icon = "flask" }
    }
}

Shared.Debug = false

return Shared
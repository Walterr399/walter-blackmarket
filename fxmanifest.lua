fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Walterr399"
description "A configurable blackmarket resource for fivem."
version "1.0.0"

dependencies {
    "es_extended",
    "ox_lib",
    "ox_inventory",
    "vx_lib"
}

shared_scripts {
    "@ox_lib/init.lua",
    "@vx_lib/init.lua",
    "@es_extended/imports.lua",
    "shared/*.lua"
}

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}
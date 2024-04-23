SimpleScripts = {}

--STANDART NOTFIY von SIMPLESCRIPTS.eu | Dafür muss SimpleNotify Installiert sein!
SimpleScripts.SimpleNotify = true

--CUSTOM NOTIFY
SimpleScripts.UseCustomNotify = false

function SimpleNotifyServer(source, color, title, msg)
    TriggerClientEvent("notifications", source, color, title, msg) -- Dein Notify Server Trigger, falls du eine eigene Nutzt.
end

SimpleScripts.ErfolgreichHeader = "Erfolg"
SimpleScripts.Erfolgreich = "Einkauf erfolgreich!"
SimpleScripts.ErfolgreichFarbe = "GREEN"

SimpleScripts.FehlgeschlagenHeader = "Erfolg"
SimpleScripts.Fehlgeschlagen = "Du hast nicht genügend Bargeld"
SimpleScripts.FehlgeschlagenFarbe = "RED"

SimpleScripts.DrawMarkerTyp = 29
SimpleScripts.DrawMarkerRBG1 = 118
SimpleScripts.DrawMarkerRBG2 = 221
SimpleScripts.DrawMarkerRBG3 = 100

SimpleScripts.Shops = {
    ["supermarket"] = { 
        enabled = true,
        sprite = 52,
        display = 2,
        scale = 0.7,
        color = 26,
        shortrange = true,
        text = "Supermarkt",
        Shops = {
            vector3(373.875, 325.896, 103.566),
            vector3(2557.458, 382.282, 108.622),
            vector3(-3038.939, 585.954, 7.908),
            vector3(-3241.927, 1001.462, 12.830),
            vector3(1961.464, 3740.672, 32.343),
            vector3(2678.916, 3280.671, 55.241),
            vector3(1729.216, 6414.131, 35.037),
            vector3(1135.808, -982.281, 46.415),
            vector3(-1222.915, -906.983, 12.326),
            vector3(-1487.553, -379.107, 40.163),
            vector3(-2968.243, 390.910, 15.043),
            vector3(1166.024, 2708.930, 38.157),
            vector3(1392.562, 3604.684, 34.980),
            vector3(-48.519, -1757.514, 29.421),
            vector3(1163.373, -323.801, 69.205),
            vector3(-707.501, -914.260, 19.215),
            vector3(-1820.523, 792.518, 138.118),
            vector3(1698.388, 4924.404, 42.063),
            vector3(26.16, -1346.84, 29.48),
            vector3(-1069.21, -2835.35, 27.7),
            vector3(4493.92, -4525.67, 4.41)
        }
    }
}

SimpleScripts.Items = {
    ["supermarket"] = { 
        ["Items"] = { 
            {
                name = "phone",
                label = "Handy",
                itemkategorie = "Item",
                price = 50,
                type = "item" 
            },
            {
                name = "medikit",
                label = "Verbandskasten",
                itemkategorie = "Item",
                price = 50,
                type = "item"
            },
            {
                name = "repairkit",
                label = "Reparaturkasten",
                itemkategorie = "Item",
                price = 58,
                type = "item"
            },
        },
    }
}
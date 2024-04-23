local ESX = exports['es_extended']:getSharedObject()
local webhookUrl = Simple_Security.Webhook

function getAllIdentifiers(source)
    local identifiers = GetPlayerIdentifiers(source)
    local SimpleIds = {}
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            SimpleIds.steam = v
        elseif string.find(v, "discord") then
            SimpleIds.discord = v
        elseif string.find(v, "license") then
            SimpleIds.license = v
        elseif string.find(v, "xbl") then
            SimpleIds.xbl = v
        end
    end
    return SimpleIds
end

RegisterServerEvent('SimpleScriptsShop')
AddEventHandler('SimpleScriptsShop', function(items, paymentType)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local totalPrice = 0
    local alreadyCalculated = {}
    local boughtItemsLog = ""

    if xPlayer then
        for _, item in ipairs(items) do
            local itemName = item.item
            local itemAmount = item.amount

            for shopType, shopData in pairs(SimpleScripts.Items) do
                for category, categoryData in pairs(shopData) do
                    for _, shopItem in ipairs(categoryData) do
                        if shopItem.name == itemName and not alreadyCalculated[itemName] then
                            totalPrice = totalPrice + (shopItem.price * itemAmount)
                            alreadyCalculated[itemName] = true 
                            boughtItemsLog = boughtItemsLog .. itemAmount .. "x " .. itemName .. "\n"
                        end
                    end
                end
            end
        end

        if paymentType == "money" then
            if xPlayer.getMoney() >= totalPrice then
                for _, item in ipairs(items) do
                    local itemName = item.item
                    local itemAmount = item.amount
                    xPlayer.addInventoryItem(itemName, itemAmount)
                end
                xPlayer.removeMoney(totalPrice)
                if SimpleScripts.SimpleNotify == true then
                    TriggerClientEvent('SimpleNotify', source, "Success", SimpleScripts.Erfolgreich)
                end
                if SimpleScripts.UseCustomNotify == true then
                    SimpleNotifyServer(source, SimpleScripts.ErfolgreichFarbe, SimpleScripts.ErfolgreichHeader, SimpleScripts.Erfolgreich)
                end

                local identifiers = getAllIdentifiers(_source)
                local discordEmbed = {
                    {
                        ["color"] = Simple_Security.Farbe, 
                        ["title"] = Simple_Security.Titel,
                        ["description"] = Simple_Security.Beschreibung,
                        ["fields"] = {
                            {
                                ["name"] = Simple_Security.Name,
                                ["value"] = xPlayer.getName()
                            },
                            {
                                ["name"] = Simple_Security.Produkte,
                                ["value"] = boughtItemsLog
                            },
                            {
                                ["name"] = Simple_Security.Gesamtpreis,
                                ["value"] = totalPrice .. " $"
                            },
                            {
                                ["name"] = Simple_Security.SpielerIds,
                                ["value"] = "Steam: " .. (identifiers.steam or "N/A") .. "\nDiscord: " .. (identifiers.discord or "N/A") .. "\nLicense: " .. (identifiers.license or "N/A") .. "\nXBL: " .. (identifiers.xbl or "N/A")
                            }
                        },
                        ["footer"] = {
                            ["text"] = Simple_Security.Footer
                        }
                    }
                }
                PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = discordEmbed}), {['Content-Type'] = 'application/json'})
            else
                if SimpleScripts.SimpleNotify == true then
                    TriggerClientEvent('SimpleNotify', source, "Error", SimpleScripts.Fehlgeschlagen)
                end
                if SimpleScripts.UseCustomNotify == true then
                    SimpleNotifyServer(source, SimpleScripts.FehlgeschlagenFarbe, SimpleScripts.FehlgeschlagenHeader, SimpleScripts.Fehlgeschlagen)
                end
            end
        elseif paymentType == "bank" then
            if xPlayer.getAccount("bank").money >= totalPrice then
                for _, item in ipairs(items) do
                    local itemName = item.item
                    local itemAmount = item.amount
                    xPlayer.addInventoryItem(itemName, itemAmount)
                end
                xPlayer.removeAccountMoney("bank", totalPrice)
                if SimpleScripts.SimpleNotify == true then
                    TriggerClientEvent('SimpleNotify', source, "Success", SimpleScripts.Erfolgreich)
                end
                if SimpleScripts.UseCustomNotify == true then
                    SimpleNotifyServer(source, SimpleScripts.ErfolgreichFarbe, SimpleScripts.ErfolgreichHeader, SimpleScripts.Erfolgreich)
                end

                local identifiers = getAllIdentifiers(_source)
                local discordEmbed = {
                    {
                        ["color"] = Simple_Security.Farbe, 
                        ["title"] = Simple_Security.Titel,
                        ["description"] = Simple_Security.Beschreibung,
                        ["fields"] = {
                            {
                                ["name"] = Simple_Security.Name,
                                ["value"] = xPlayer.getName()
                            },
                            {
                                ["name"] = Simple_Security.Produkte,
                                ["value"] = boughtItemsLog
                            },
                            {
                                ["name"] = Simple_Security.Gesamtpreis,
                                ["value"] = totalPrice .. " $"
                            },
                            {
                                ["name"] = Simple_Security.SpielerIds,
                                ["value"] = "Steam: " .. (identifiers.steam or "N/A") .. "\nDiscord: " .. (identifiers.discord or "N/A") .. "\nLicense: " .. (identifiers.license or "N/A") .. "\nXBL: " .. (identifiers.xbl or "N/A")
                            }
                        },
                        ["footer"] = {
                            ["text"] = Simple_Security.Footer
                        }
                    }
                }
                PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = discordEmbed}), {['Content-Type'] = 'application/json'})
            else
                if SimpleScripts.SimpleNotify == true then
                    TriggerClientEvent('SimpleNotify', source, "Error", SimpleScripts.Fehlgeschlagen)
                end
                if SimpleScripts.UseCustomNotify == true then
                    SimpleNotifyServer(source, SimpleScripts.FehlgeschlagenFarbe, SimpleScripts.FehlgeschlagenHeader, SimpleScripts.Fehlgeschlagen)
                end            
            end
        else
            if SimpleScripts.SimpleNotify == true then
                TriggerClientEvent('SimpleNotify', source, "Error", 'Ungültige Zahlungsmethode')
            end
            if SimpleScripts.UseCustomNotify == true then
                SimpleNotifyServer(source, "RED", "ERROR", 'Ungültige Zahlungsmethode')
            end
        end
    else
        print("Spieler nicht gefunden!")
    end
end)
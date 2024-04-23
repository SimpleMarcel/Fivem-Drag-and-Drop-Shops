local ESX = exports['es_extended']:getSharedObject()
local currentShop 
local PlayerData = {}

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
  PlayerData.job = job
end)
      
Citizen.CreateThread(function()
Wait(1000)
for k,v in pairs(SimpleScripts.Shops) do 
    if v.enabled then
    for q, z in pairs(v.Shops) do
        local blip = AddBlipForCoord(z.x, z.y, z.z)
        SetBlipSprite(blip, v.sprite)
        SetBlipDisplay(blip, v.display)
        SetBlipScale(blip, v.scale)
        SetBlipColour(blip, v.color)
        SetBlipAsShortRange(blip, v.shortrange)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.text)
        EndTextCommandSetBlipName(blip)
        end
      end
    end
end)

Citizen.CreateThread(function()
  while true do 
    Wait(0)
    local coords = GetEntityCoords(PlayerPedId())
    local canSleep = true
    for k,v in pairs(SimpleScripts.Shops) do
      for q, z in pairs(v.Shops) do
        local distance = #(coords - z)
        if distance <= 10.0 then 
          canSleep = false 
          DrawMarker(SimpleScripts.DrawMarkerTyp, z.x, z.y, z.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 8, SimpleScripts.DrawMarkerRBG1, SimpleScripts.DrawMarkerRBG2, SimpleScripts.DrawMarkerRBG3, false, false, false, true, 0, 0, 0)
          if distance <= 1.5 then 
            ESX.ShowHelpNotification("Drücke ~INPUT_PICKUP~ zum interagieren")
            if IsControlJustPressed(0, 38) then
              if k == "frakshop" then
                if PlayerData.job.name == 'unemployed' then
                else
                  OpenShop(k)
                  currentShop = k
                end
              else
                OpenShop(k)
                currentShop = k
              end
            end
          end
        end
      end
    end
    if canSleep then 
      Wait(1500)
    end
  end
end)

function OpenShop(shop)
  SetNuiFocus(true, true)
  SendNUIMessage({clear = true})
  for k1,v1 in pairs(SimpleScripts.Items[shop]) do 
    for k, v in pairs(v1) do 
      SendNUIMessage({
        category = k1,
        name = v.name,
        itemkategorie = v.itemkategorie,
        label = v.label,
        price = v.price,
        type = v.type,
      })
    end
  end
  for k1,v1 in pairs(SimpleScripts.Items[shop]) do 
    SendNUIMessage({categoryName = k1,})
  end
  SendNUIMessage({display = true})
end

RegisterNUICallback('exit', function()
  SendNUIMessage({display = false})
  SetNuiFocus(false, false)
  currentShop = nil
end)

RegisterNUICallback('SimpleScriptsBuy', function(data)
  local items = data.items
  local paymentType = data.payment    
  TriggerServerEvent('SimpleScriptsShop', items, paymentType); 
  SendNUIMessage({display = false})
  SetNuiFocus(false, false)
end)
    
    
    
    
    


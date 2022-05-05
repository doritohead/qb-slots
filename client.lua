-- This resource was made by plesalex100#7387
-- Please respect it, don't repost it without my permission
-- This Resource started from: https://codepen.io/AdrianSandu/pen/MyBQYz
-- ESX Version: saNhje & wUNDER
-- Rewritten from ESX to QB: Revoxxi
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData                = {}
local playerUpdate			    = false
local open 						= false

Citizen.CreateThread(function()
    if playerUpdate == false then
        PlayerData = QBCore.Functions.GetPlayerData()
        CreateBlip()
		playerUpdate = true
    end
end)

-------------------------------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------------------------------
local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CreateBlip()
	if Config.blipsEnabled then
		for k,v in ipairs(Config.Slots)do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, 436)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 1.0)
			SetBlipColour(blip, 49)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Slotmachine")
			EndTextCommandSetBlipName(blip)
		end
	end
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

-------------------------------------------------------------------------------
-- NET EVENTS
-------------------------------------------------------------------------------
RegisterNetEvent("qb-slots:enterBets")
AddEventHandler("qb-slots:enterBets", function ()
    local bets = KeyboardInput("Enter bet value:", "", Config.MaxBetNumbers)
    if tonumber(bets) ~= nil then
    	TriggerServerEvent('qb-slots:BetsAndMoney', tonumber(bets))
    else
		QBCore.Functions.Notify('You need to enter numbers (999 is max bet).', "error")
    end
end)

RegisterNetEvent("qb-slots:UpdateSlots")
AddEventHandler("qb-slots:UpdateSlots", function(lei)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(lei)
	})
end)

-------------------------------------------------------------------------------
-- NUI CALLBACKS
-------------------------------------------------------------------------------
RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	TriggerServerEvent("qb-slots:PayOutRewards", GetPlayerServerId(PlayerId()), data.coinAmount)
	open = false
	SetNuiFocus(false, false)
end)

-------------------------------------------------------------------------------
-- THREADS
-------------------------------------------------------------------------------
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		end
	end
end)

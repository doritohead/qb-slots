-- This resource was made by plesalex100#7387
-- Please respect it, don't repost it without my permission
-- This Resource started from: https://codepen.io/AdrianSandu/pen/MyBQYz
-- ESX Version: saNhje & wUNDER
-- Rewritten from ESX to QB: Revoxxi
local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("qb-slots:BetsAndMoney")
AddEventHandler("qb-slots:BetsAndMoney", function(bets)
    local src   = source
	local Player = QBCore.Functions.GetPlayer(source)
	local PlayerData = Player.PlayerData
    if PlayerData then
        if bets % 10 == 0 and bets >= 10 then
            local chips = Player.Functions.GetItemByName('casino_whitechip')
            if chips and chips.amount >= bets then
            --if PlayerData.money['cash'] >= bets then
                --Player.Functions.RemoveMoney('cash', bets)
                Player.Functions.RemoveItem('casino_whitechip', bets)
                TriggerEvent("qb-log:server:CreateLog", "casino", "Slot Machines", "red", " "..GetPlayerName(source) .. ' Put '..bets..' Chips on the slots')
                TriggerClientEvent("qb-slots:UpdateSlots", src, bets)
            else
                TriggerClientEvent('QBCore:Notify', src, "You need more White Chips.", "error")
            end
        else
			TriggerClientEvent('QBCore:Notify', src, "You have to insert a multiple of 10. ex: 10, 20, 30 etc...", "error")
        end

    end
end)

RegisterServerEvent("qb-slots:PayOutRewards")
AddEventHandler("qb-slots:PayOutRewards", function(source, amount)
    local src   = source
    local PlayerData = QBCore.Players[src].PlayerData
	local Player = QBCore.Functions.GetPlayer(source)
    if PlayerData then
        amount = tonumber(amount)
        if amount > 0 then
            Player.Functions.AddItem('casino_whitechip', amount)
            TriggerEvent("qb-log:server:CreateLog", "casino", "Slot Machines", "green", " "..GetPlayerName(source) .. ' Walked away with '..amount..' Chips from the slots')
			TriggerClientEvent('QBCore:Notify', src, 'You walked away with £'..amount.. ' in chips', 'success')
        elseif amount <= 0 then
			TriggerClientEvent('QBCore:Notify', src, 'Unlucky, maybe next time!', 'error')
            TriggerEvent("qb-log:server:CreateLog", "casino", "Slot Machines", "red", " "..GetPlayerName(source) .. ' Lost money on the slots')
        end
    end
end)

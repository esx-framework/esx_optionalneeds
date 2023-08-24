ESX.RegisterUsableItem('beer', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, TranslateCap('used_beer'))

end)

---Drugs Items
ESX.RegisterUsableItem('coke_pooch', function(source)
       
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coke_pooch', 1)

	TriggerClientEvent('esx_status:add', source, 'drug', 499000)
	TriggerClientEvent('esx_optionalneeds:useItemCoke', source)
	TriggerClientEvent('esx:showNotification', source, TranslateCap('used_one_coke'))
end)

ESX.RegisterUsableItem('weed', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_status:add', source, 'drug', 166000)
	TriggerClientEvent('esx_optionalneeds:onWeed', source)
	TriggerClientEvent('esx:showNotification', source, TranslateCap('used_one_weed'))
end)

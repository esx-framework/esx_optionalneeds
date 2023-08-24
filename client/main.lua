local IsAlreadyDrunk = false
local DrunkLevel     = -1
local IsAlreadyDrug = false
local DrugLevel = -1

function Drunk(level, start)
  
  CreateThread(function()

    local playerPed = PlayerPedId()

    if start then
      DoScreenFadeOut(800)
      Wait(1000)
    end

    if level == 0 then

      RequestAnimSet("move_m@drunk@slightlydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Wait(0)
      end

      SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)

    elseif level == 1 then

      RequestAnimSet("move_m@drunk@moderatedrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Wait(0)
      end

      SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

    elseif level == 2 then

      RequestAnimSet("move_m@drunk@verydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Wait(0)
      end

      SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)

    end

    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedIsDrunk(playerPed, true)

    if start then
      DoScreenFadeIn(800)
    end

  end)

end

function Reality()

  CreateThread(function()

    local playerPed = PlayerPedId()

    DoScreenFadeOut(800)
    Wait(1000)

    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)

    DoScreenFadeIn(800)

  end)

end

AddEventHandler('esx_status:loaded', function(status)

  TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5', 
    function(status)
      if status.val > 0 then
        return true
      else
        return false
      end
    end,
    function(status)
      status.remove(1500)
    end
  )

	CreateThread(function()

		while true do

			Wait(1000)

			TriggerEvent('esx_status:getStatus', 'drunk', function(status)
				
				if status.val > 0 then
					
          local start = true

          if IsAlreadyDrunk then
            start = false
          end

          local level = 0

          if status.val <= 250000 then
            level = 0
          elseif status.val <= 500000 then
            level = 1
          else
            level = 2
          end

          if level ~= DrunkLevel then
            Drunk(level, start)
          end

          IsAlreadyDrunk = true
          DrunkLevel     = level
				end

				if status.val == 0 then
          
          if IsAlreadyDrunk then
            Reality()
          end

          IsAlreadyDrunk = false
          DrunkLevel     = -1

				end

			end)

		end

	end)

end)

RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
  
  local playerPed = PlayerPedId()
  
  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  Wait(1000)
  ClearPedTasksImmediately(playerPed)

end)

------DRUGS---------
AddEventHandler('esx_status:loaded', function(status)
	TriggerEvent('esx_status:registerStatus', 'drug', 0, '#9ec617',
		function(status)
			if status.val > 0 then
				return false
			else
				return false
			end
		end, function(status)
			status.remove(1500)
		end)

	Citizen.CreateThread(function()
		while true do
			Wait(1000)

			TriggerEvent('esx_status:getStatus', 'drug', function(status)
				if status.val > 0 then
					local start = true

					if IsAlreadyDrug then
						start = false
					end

					local level = 0

					if status.val <= 950000 then
						level = 0
					else
						overdose()
					end

					if level ~= DrugLevel then
					end

					IsAlreadyDrug = true
					DrugLevel = level
				end

				if status.val == 0 then
					if IsAlreadyDrug then
						Normal()
					end

					IsAlreadyDrug = false
					DrugLevel     = -1
				end
			end)
		end
	end)
end)

--When effects ends go back to normal
function Normal()
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()

		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedMotionBlur(playerPed, false)
	end)
end

--In case too much drugs dies of overdose set everything back
function overdose()
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()

		SetEntityHealth(playerPed, 0)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedMotionBlur(playerPed, false)
		ESX.ShowNotification(TranslateCap('overdose'))
	end)
end

-- Cocaine effect (Run really fast + paranoïa move + auto-jump)
RegisterNetEvent('esx_optionalneeds:runMan')
AddEventHandler('esx_optionalneeds:runMan', function()
	RequestAnimSet("move_m@hurry_butch@b")
	while not HasAnimSetLoaded("move_m@hurry_butch@b") do
		Citizen.Wait(0)
	end
	onDrugs = true
	count = 0
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	SetPedMotionBlur(PlayerPedId(), true)
	SetTimecycleModifier("spectator5")
	SetPedMovementClipset(PlayerPedId(), "move_m@hurry_butch@b", true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
	DoScreenFadeIn(1000)
	repeat
		ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
		TaskJump(PlayerPedId(), false, true, false)
		Citizen.Wait(20000)
		count = count + 1
	until count == 16
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetPedMovementClipset(PlayerPedId(), 0)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	ClearAllPedProps(PlayerPedId(), true)
	SetPedMotionBlur(PlayerPedId(), false)
	ESX.ShowNotification(TranslateCap('effects_disapear')
	onDrugs = false
end)

--- Weed effect (sprint speed reduced)

RegisterNetEvent('esx_optionalneeds:onWeed')
AddEventHandler('esx_optionalneeds:onWeed', function()
	local playerPed = PlayerPedId()

	RequestAnimSet("move_m@hipster@a")
	while not HasAnimSetLoaded("move_m@hipster@a") do
		Citizen.Wait(0)
	end

	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
	Citizen.Wait(3000)
	ClearPedTasksImmediately(playerPed)
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(playerPed, true)
	SetPedMovementClipset(playerPed, "move_m@hipster@a", true)

	--Effects
	local player = PlayerId()
	SetRunSprintMultiplierForPlayer(player, 0.7)

	Wait(300000)

	SetRunSprintMultiplierForPlayer(player, 1.0)
end)

-- Useitem thread
RegisterNetEvent('esx_optionalneeds:useItemCoke')
AddEventHandler('esx_optionalneeds:useItemCoke', function()

	--local lib, anim = 'anim@amb@nightclub@peds@', 'missfbi3_party_snort_coke_b_male3' -- Play animation sitting and snorting
	local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
	local playerPed = PlayerPedId()
	ESX.ShowNotification(TranslateCap('drugs_taken')
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

		Citizen.Wait(500)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		TriggerEvent('esx_optionalneeds:runMan')
	end)
end)

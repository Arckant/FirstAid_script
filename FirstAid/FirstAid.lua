player = GetPlayerPed(-1)

poses = {}
poses['mse'] = {dict = 'amb@medic@standing@tendtodead@enter', clip = 'enter'}
poses['msb'] = {dict = 'amb@medic@standing@tendtodead@base', clip = 'base'}
poses['pf1'] = {dict = 'combat@drag_ped@', clip = 'injured_pickup_front_plyr'}
poses['pl1'] = {dict = 'combat@drag_ped@', clip = 'injured_pickup_side_left_plyr'}
poses['pr1'] = {dict = 'combat@drag_ped@', clip = 'injured_pickup_side_right_plyr'}
poses['pf2'] = {dict = 'combat@drag_ped@', clip = 'injured_pickup_front_ped'}
poses['pl2'] = {dict = 'combat@drag_ped@', clip = 'injured_pickup_side_left_ped'}
poses['pr2'] = {dict = 'combat@drag_ped@', clip = 'injured_pickup_side_right_ped'}
poses['bs'] = {dict = 'anim@gangops@morgue@table@', clip = 'body_search'}
poses['fs'] = {dict = 'amb@lo_res_idles@', clip = 'lying_face_down_lo_res_base'}
poses['ls'] = {dict = 'amb@lo_res_idles@', clip = 'world_human_bum_slumped_left_lo_res_base'}
poses['rs'] = {dict = 'amb@lo_res_idles@', clip = 'world_human_bum_slumped_right_lo_res_base',}

act = {}

function GetHeading(playerped, pos)
  local yaw = GetEntityHeading(playerped)
  if GetCurrentPose(playerped) == 'fs' then
    if pos == 'tp' then
      yaw = yaw + 0.0
    elseif pos == 'lt' then
      yaw = yaw + -320.0
    elseif pos == 'lm' then
      yaw = yaw + -270.0
    elseif pos == 'ld' then
      yaw = yaw + -225.0
    elseif pos == 'rt' then
      yaw = yaw + 325.0
    elseif pos == 'rm' then
      yaw = yaw + 270.0
    elseif pos == 'rd' then
      yaw = yaw + 225.0
    elseif pos == 'dn' then
      yaw = yaw + 180.0
    end

  elseif GetCurrentPose(playerped) == 'ls' then
    if pos == 'tp' then
      yaw = yaw + 90.0
    elseif pos == 'lt' then
      yaw = yaw + 120.0
    elseif pos == 'lm' then
      yaw = yaw + 180.0
    elseif pos == 'ld' then
      yaw = yaw + -90.0
    elseif pos == 'rt' then
      yaw = yaw + 80.0
    elseif pos == 'rm' then
      yaw = yaw + 35.0
    elseif pos == 'rd' then
      yaw = yaw + 0.0
    elseif pos == 'dn' then
      yaw = yaw + -40.0
    end

  elseif GetCurrentPose(playerped) == 'rs' then
    if pos == 'tp' then
      yaw = yaw + -90.0
    elseif pos == 'lt' then
      yaw = yaw + -50.0
    elseif pos == 'lm' then
      yaw = yaw + -20.0
    elseif pos == 'ld' then
      yaw = yaw + 40.0
    elseif pos == 'rt' then
      yaw = yaw + -100.0
    elseif pos == 'rm' then
      yaw = yaw + 200.0
    elseif pos == 'rd' then
      yaw = yaw + 110.0
    elseif pos == 'dn' then
      yaw = yaw + 80.0
    end

  else
    if pos == 'tp' then
      yaw = yaw + 180.0
    elseif pos == 'lt' then
      yaw = yaw + -140.0
    elseif pos == 'lm' then
      yaw = yaw + -90.0
    elseif pos == 'ld' then
      yaw = yaw + -45.0
    elseif pos == 'rt' then
      yaw = yaw + 145.0
    elseif pos == 'rm' then
      yaw = yaw + 90.0
    elseif pos == 'rd' then
      yaw = yaw + 45.0
    elseif pos == 'dn' then
      yaw = yaw + 0.0
    end
  end
  
	if yaw > 180 then
		yaw = yaw - 360
	elseif yaw < -180 then
		yaw = yaw + 360
	end

  return yaw

end

function GetCamHeading()
  local pedyaw = GetEntityHeading(player)
	local camyaw = GetGameplayCamRelativeHeading(player)
	local yaw = pedyaw + camyaw
  if yaw > 180 then
		yaw = yaw - 360
	elseif yaw < -180 then
		yaw = yaw + 360
	end
  return yaw
end


function GetCurrentPose(patient)
  if IsEntityPlayingAnim(patient, poses['bs'].dict, poses['bs'].clip, 1) then
    return 'bs'
  elseif IsEntityPlayingAnim(patient, poses['fs'].dict, poses['fs'].clip, 1) then
    return 'fs'
  elseif IsEntityPlayingAnim(patient, poses['ls'].dict, poses['ls'].clip, 1) then
    return 'ls'
  elseif IsEntityPlayingAnim(patient, poses['rs'].dict, poses['rs'].clip, 1) then
    return 'rs'    
  end
end

function GetPlayerLookingVector(playerped, radius, pos)
	local pitch = 90
  local pitch = pitch * math.pi / 180
  local yaw = GetHeading(playerped, pos) * math.pi / 180
  local x = radius * math.sin(pitch) * math.sin(yaw)
  local y = radius * math.sin(pitch) * math.cos(yaw)
  local z = radius * math.cos(pitch) / 10

	local playerpedcoords = GetEntityCoords(playerped)
	local xcorr = -x+ playerpedcoords.x
	local ycorr = y+ playerpedcoords.y
	local zcorr = z+ playerpedcoords.z
  
	local Vector = vector3(tonumber(xcorr), tonumber(ycorr), tonumber(zcorr))
  
	return Vector
end

function GetPedInDirection(coordFrom, coordTo, ped)
  local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 8, ped, 0)
  local _,flag_PedHit,PedCoords,_,PedHit = GetShapeTestResult(rayHandle)
  return PedHit
end


function ClosePos(patient)
  local x, y, z
  local l = {'tp', 'lt', 'lm', 'ld', 'rt', 'rm', 'rd', 'dn'}
  local d = 999
  local h
  for k, i in pairs(l) do
    if #(GetPlayerLookingVector(patient, 1.0, i) - GetEntityCoords(player)) < d then
      d = #(GetPlayerLookingVector(patient, 1.0, i) - GetEntityCoords(player))
      h = i
      x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.0, i))      
    end
  end
  return x, y, z, h
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function FirstAid(patient, i)
  local x, y, z, h = ClosePos(patient)
  ClearPedTasks(player)
  if i == 0 then
    HealerPosition(patient, h, 0)
  else
    HealerPosition(patient, h)
  end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function HealerPosition(patient, pos, i)
  RequestAnimDict(poses['mse'].dict)
  RequestAnimDict(poses['msb'].dict)
  if not RequestAnimDict(poses['mse'].dict) and not HasAnimDictLoaded(poses['msb'].dict) then
    Citizen.Wait(1)
  end
  
  if pos == 'tp' then 
    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end

  elseif pos == 'lt' then 
    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end

  elseif pos == 'lm' then 
    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end

  elseif pos == 'ld' then 
    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end

  elseif pos == 'rt' then 
    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end
  elseif pos == 'rm' then 

    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end
  elseif pos == 'rd' then 

    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 0.75, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end
  elseif pos == 'dn' then 

    if GetCurrentPose(patient) == 'bs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.5, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'fs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.5, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'ls' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.25, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    elseif GetCurrentPose(patient) == 'rs' then
      local x, y, z = table.unpack(GetPlayerLookingVector(patient, 1.0, pos))
      SetEntityCoords(player, x, y, z-1)
      SetEntityHeading(player, GetCamHeading(player) + -30)

    end
  end

  if i == 0 then
    TaskPlayAnim(player, poses['msb'].dict, poses['msb'].clip , 8.0, 8.0, -1, 1, 0.0)
  else
    TaskPlayAnim(player, poses['mse'].dict, poses['mse'].clip , 8.0, 8.0, -1, 1, 0.0)
    Citizen.Wait(1500)
    TaskPlayAnim(player, poses['msb'].dict, poses['msb'].clip , 8.0, 8.0, -1, 1, 0.0)
  end

  RemoveAnimDict(poses['mse'].dict)
  RemoveAnimDict(poses['msb'].dict)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function PatientRotation(patient, pose)
  RequestAnimDict(poses['bs'].dict)
  RequestAnimDict(poses['fs'].dict)
  RequestAnimDict(poses['pf1'].dict)
  RequestAnimDict(poses['msb'].dict)

  if not HasAnimDictLoaded(poses['bs'].dict) and not HasAnimDictLoaded(poses['fs'].dict) and not HasAnimDictLoaded(poses['pf1'].dict) and not HasAnimDictLoaded(poses['msb'].dict) then
    Citizen.Wait(1)
  end
  local _, _, _, heading = ClosePos(patient)
  SetEntityHeading(player, GetHeading(patient, heading) + 150)

  if pose == 'bs' then
    if GetCurrentPose(patient) == 'ls' then
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pl2'].dict, poses['pl2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)

    elseif GetCurrentPose(patient) == 'rs' then
      SetEntityHeading(patient, GetHeading(patient) + 90)
      TaskPlayAnim(player, poses['pr1'].dict, poses['pr1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pr2'].dict, poses['pr2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
    elseif GetCurrentPose(patient) == 'fs' then
      SetEntityHeading(patient, GetHeading(patient) + 180)
      TaskPlayAnim(player, poses['pf1'].dict, poses['pf1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pf2'].dict, poses['pf2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)

    elseif GetCurrentPose(patient) == 'bs' then
      goto continue
    else
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
    end
    
    TaskPlayAnim(patient, poses['bs'].dict, poses['bs'].clip, 8.0, 8.0, -1, 1, 0.0)
    Citizen.Wait(10)
    FirstAid(target, 0)

  elseif pose == 'fs' then

    
    if GetCurrentPose(patient) == 'ls' then
      SetEntityHeading(patient, GetHeading(patient) + -45)
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pl2'].dict, poses['pl2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + 180)

    elseif GetCurrentPose(patient) == 'rs' then
      SetEntityHeading(patient, GetHeading(patient) + 90)
      TaskPlayAnim(player, poses['pr1'].dict, poses['pr1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pr2'].dict, poses['pr2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + 180)
    elseif GetCurrentPose(patient) == 'bs' then
      TaskPlayAnim(player, poses['pf1'].dict, poses['pf1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pf2'].dict, poses['pf2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)

      SetEntityHeading(patient, GetHeading(patient) + 180)
      
    elseif GetCurrentPose(patient) == 'fs' then
      goto continue
    else
      SetEntityHeading(patient, GetHeading(patient) + 180)
      Citizen.Wait(1)
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
    end

    TaskPlayAnim(patient, poses['fs'].dict, poses['fs'].clip, 8.0, 8.0, -1, 1, 0.0)
    Citizen.Wait(10)
    FirstAid(target, 0)

  elseif pose == 'ls' then
    if GetCurrentPose(patient) == 'fs' then
      SetEntityHeading(patient, GetHeading(patient) + 180)
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pl2'].dict, poses['pl2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + 45)

    elseif GetCurrentPose(patient) == 'rs' then
      SetEntityHeading(patient, GetHeading(patient) + 45)
      TaskPlayAnim(player, poses['pr1'].dict, poses['pr1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pr2'].dict, poses['pr2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + 90)

    elseif GetCurrentPose(patient) == 'bs' then
      TaskPlayAnim(player, poses['pf1'].dict, poses['pf1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pf2'].dict, poses['pf2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + 45)

    elseif GetCurrentPose(patient) == 'ls' then
      goto continue
    else
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + 90)
    end
    
    TaskPlayAnim(patient, poses['fs'].dict, poses['ls'].clip, 8.0, 8.0, -1, 1, 0.0)
    Citizen.Wait(10)
    FirstAid(target, 0)

  elseif pose == 'rs' then
    if GetCurrentPose(patient) == 'ls' then
      SetEntityHeading(patient, GetHeading(patient) + -45)
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pl2'].dict, poses['pl2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + -90)

    elseif GetCurrentPose(patient) == 'fs' then
      SetEntityHeading(patient, GetHeading(patient) + 180)
      TaskPlayAnim(player, poses['pr1'].dict, poses['pr1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pr2'].dict, poses['pr2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + -90)
    elseif GetCurrentPose(patient) == 'bs' then
      TaskPlayAnim(player, poses['pf1'].dict, poses['pf1'].clip, 8.0, 8.0, -1, 0, 0.0)
      TaskPlayAnim(patient, poses['pf2'].dict, poses['pf2'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + -90)

    elseif GetCurrentPose(patient) == 'rs' then
      goto continue
    else
      TaskPlayAnim(player, poses['pl1'].dict, poses['pl1'].clip, 8.0, 8.0, -1, 0, 0.0)
      Citizen.Wait(2000)
      SetEntityHeading(patient, GetHeading(patient) + -90.0)
    end
    
    TaskPlayAnim(patient, poses['fs'].dict, poses['rs'].clip, 8.0, 8.0, -1, 1, 0.0)
    Citizen.Wait(10)
    FirstAid(target, 0)
    
  end

  SetEntityHeading(player, GetHeading(patient, heading) + 150)
  
  ::continue::
  RemoveAnimDict(poses['bs'].dict)
  RemoveAnimDict(poses['fs'].dict)
  RemoveAnimDict(poses['pf1'].dict)
  RemoveAnimDict(poses['msb'].dict)

end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function action()

end

currentpatient = {}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
  while true do
    RegisterCommand("hp", function(source, args, rawCommand)
      HealerPosition(target, args)
    end, false)
    
    x3, y3, z3 = table.unpack(GetEntityCoords(player))
    x4, y4, z4 = table.unpack(GetPlayerLookingVector(player, 1))

    p2 = vector3(x3,y3,z3-0.9)
    h2 = vector3(x4,y4,z4-0.9)

    if IsEntityAPed(GetPedInDirection(p2, h2, player)) then
      target = GetPedInDirection(p2, h2, player)
      currentpatient['patient'] = target
    elseif currentpatient['patient'] ~= nil and #(GetEntityCoords(currentpatient['patient']) - GetEntityCoords(player)) < 2 then
      target = currentpatient['patient']  
    else
      target = ''    
    end
    
    if IsControlJustReleased(1, 289) then -------------- F2
      ClearPedTasks(player)
      DetachEntity(player, 1, 1)
    end

    if IsControlJustReleased(1, 170) then -------------- F3
      RequestAnimDict('combat@drag_ped@')
      
      if not HasAnimDictLoaded('combat@drag_ped@') then
        Citizen.Wait(1)
      end
      TaskPlayAnim(player, 'combat@drag_ped@', 'injured_pickup_front_plyr', 8.0, 8.0, -1, 0, 0.0)

    end

    if IsEntityAPed(target) then

      if IsControlJustReleased(1, 288) then -------------- F1
        FirstAid(target, 0)
      end

        
      if IsControlJustReleased(1, 124) then
        HealerPosition(target, 'lt')
      end
      if IsControlJustReleased(1, 126) then
        HealerPosition(target, 'lm')
      end
      if IsControlJustReleased(1, 125) then
        HealerPosition(target, 'ld')
      end
      if IsControlJustReleased(1, 117) then
        HealerPosition(target, 'rt')
      end
      if IsControlJustReleased(1, 127) then
        HealerPosition(target, 'rm')
      end
      if IsControlJustReleased(1, 118) then
        HealerPosition(target, 'rd')
      end
      if IsControlJustReleased(1, 172) then
        PatientRotation(target, 'bs')
      end
      if IsControlJustReleased(1, 173) then
        PatientRotation(target, 'fs')
      end
      if IsControlJustReleased(1, 174) then
        PatientRotation(target, 'ls')
      end
      if IsControlJustReleased(1, 175) then
        PatientRotation(target, 'rs')
      end
      -- if IsControlJustReleased(1, 172) then
      --   HealerPosition(target, 'tp')
      -- end
      -- if IsControlJustReleased(1, 173) then
      --   HealerPosition(target, 'dn')
      -- end
    end

    -- DrawLine(ClosePos(target), GetEntityCoords(player), 255, 0, 255, 10000)
    Citizen.Wait(1)
  end
end)
--local ped = PlayerPedId()
--Citizen.CreateThread(function()
--	while true do
--		if IsControlJustReleased(1, 288) then -- F1
--  		TriggerEvent("FirstAid")
--  		--local _, _, _, _, patient = GetShapeTestResult(StartShapeTestRay(GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -0.9),GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0), 4, ped, 0))
--			--print(patient)
--
--			end
--
--		if IsControlJustReleased(1, 289) then -- F2
--			ClearPedTasksImmediately(GetPlayerPed(-1))
--			DetachEntity(ped, 1, 1)
--		end
--		
--		if IsControlJustReleased(1, 170) then -- F2
--			TriggerEvent("Action", "CPR")
--			--target = GetPedInDirection(playerpedcoords, GetPlayerLookingVector(GetPlayerPed(-1), 5))
--			--print(target)
--			--RequestAnimDict('wallclimb1@anim')
--			--while not HasAnimDictLoaded('wallclimb1@anim') do
--			--	Wait(1)
--			--end
--			--TaskPlayAnim(7602948, 'wallclimb1@anim', 'wallclimb1_clip', 8.0, 8.0, -1, 1026, 0.0)
--			--RemoveAnimDict('wallclimb1@anim')
--		end
--		if IsControlJustReleased(1, 124) then
--      TriggerEvent("HealerPosition", "left_top")
--    end
--    if IsControlJustReleased(1, 126) then
--      TriggerEvent("HealerPosition", "left_middle")
--    end
--    if IsControlJustReleased(1, 125) then
--      TriggerEvent("HealerPosition", "left_down")
--    end
--    if IsControlJustReleased(1, 117) then
--      TriggerEvent("HealerPosition", "right_top")
--    end
--    if IsControlJustReleased(1, 127) then
--      TriggerEvent("HealerPosition", "right_middle")
--    end
--    if IsControlJustReleased(1, 118) then
--      TriggerEvent("HealerPosition", "right_down")
--    end
--    if IsControlJustReleased(1, 172) then
--      TriggerEvent("PatientRotation", "back_side")
--    end
--    if IsControlJustReleased(1, 173) then
--      TriggerEvent("PatientRotation", "front_side")
--    end
--    if IsControlJustReleased(1, 174) then
--      TriggerEvent("PatientRotation", "left_side")
--    end
--    if IsControlJustReleased(1, 175) then
--      TriggerEvent("PatientRotation", "right_side")
--    end
--    if IsControlJustReleased(1, 314) then
--      TriggerEvent("HealerPosition", "top")
--    end
--    if IsControlJustReleased(1, 315) then
--      TriggerEvent("HealerPosition", "down")
--    end
--    DrawLine(GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -0.9),GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.9), 255, 1, 1, 100)
--		Citizen.Wait(1)
--	end
--end)

local patient
local currentpose = "back_side"
target_offset = {
	["back_side"] = {
                  ["top"]            = {vector3(0.0, -1.25, 0.0), 180.0,},
                  ["down"]           = {vector3(0.0, 1.5, 0.0), 0.0,},
                  ["left_top"]       = {vector3(0.6427872, -0.7660448, 0.0), -140.0,},
                  ["right_top"]      = {vector3(-0.5735769, -0.8191518, 0.0), 145.0,},
                  ["left_middle"]    = {vector3(0.75, 0.0, 0.0), -90.0,},
                  ["right_middle"]   = {vector3(-0.75, 0.0, 0.0), 90.0,},
                  ["left_down"]      = {vector3(0.7071072, 0.7071064, 0.0), -45.0,},
                  ["right_down"]     = {vector3(-0.7071064, 0.7071072, 0.0), 45.0,},
                   },
	["front_side"] = {  
                    ["top"]          = {vector3(0.0, 1.25, 0.0), 0.0},
                    ["down"]         = {vector3(0.0, -1.5, 0.0), 180.0},
                    ["left_top"]     = {vector3(-0.642788, 0.7660441, 0.0), -320.0},
                    ["right_top"]    = {vector3(0.573576, 0.8191523, 0.0), 325.0},
                    ["left_middle"]  = {vector3(-0.75, 0.0, 0.0), -270.0},
                    ["right_middle"] = {vector3(0.75, 0.0, 0.0), 270.0},
                    ["left_down"]    = {vector3(-0.7071065, -0.7071071, 0.0), -225.0},
                    ["right_down"]   = {vector3(0.7071071, -0.7071065, 0.0), 225.0},
                  },
	["left_side"] = {
                   ["top"]           = {vector3(-1.25, 0.0, 0.0), 90.0},
                   ["down"]          = {vector3(0.8034845, 0.9575555, 0.0), -40.0},
                   ["left_top"]      = {vector3(-1.082532, -0.625, 0.0), 120.0},
                   ["right_top"]     = {vector3(-1.23101, 0.2170602, 0.0), 80.0},
                   ["left_middle"]   = {vector3(0.0, -0.75, 0.0), 180.0},
                   ["right_middle"]  = {vector3(-0.5735765, 0.8191521, 0.0), 35.0},
                   ["left_down"]     = {vector3(0.75, 0.0, 0.0), -90.0},
                   ["right_down"]    = {vector3(0, 1.25, 0.0), 0.0},
                   },
	["right_side"] = {
                   ["top"]           = {vector3(1.25, 0.0, 0.0), -90.0},
                   ["down"]          = {vector3(-0.9848078, 0.1736481, 0.0), 80.0},
                   ["left_top"]      = {vector3(0.9575555, 0.8034846, 0.0), -50.0},
                   ["right_top"]     = {vector3(0.9848078, -0.1736481, 0.0), -100.0},
                   ["left_middle"]   = {vector3(0.3420201, 0.9396926, 0.0), -20.0},
                   ["right_middle"]  = {vector3(0.2565151, -0.7047694, 0.0), 200.0},
                   ["left_down"]     = {vector3(-0.6427876, 0.7660444, 0.0), 40.0},
                   ["right_down"]    = {vector3(-0.7047694, -0.2565151, 0.0), 110.0},
                  }
}

local poses = {
	{'amb@medic@standing@tendtodead@enter', 'enter'},
  {'amb@medic@standing@tendtodead@base', 'base'},
  {'combat@drag_ped@', 'injured_pickup_front_plyr'},
  {'combat@drag_ped@', 'injured_pickup_side_left_plyr'},
  {'combat@drag_ped@', 'injured_pickup_side_right_plyr'},
  {'combat@drag_ped@', 'injured_pickup_front_ped'},
  {'combat@drag_ped@', 'injured_pickup_side_left_ped'},
  {'combat@drag_ped@', 'injured_pickup_side_right_ped'},
  {'anim@gangops@morgue@table@', 'body_search'},
  {'amb@lo_res_idles@', 'lying_face_down_lo_res_base'},
  {'amb@lo_res_idles@', 'world_human_bum_slumped_left_lo_res_base'},
  {'amb@lo_res_idles@', 'world_human_bum_slumped_right_lo_res_base'}
}
local actions = {
	{'missheistfbi3b_ig8_2', 'cpr_loop_paramedic'},
  {'missheistfbi3b_ig8_2', 'cpr_loop_victim'},
}
function ClosePos(ps)
  local ped = PlayerPedId()
  local currentpose = GetCurrentPose()
  local d = 3
  local position = {'top', 'down', 'left_top', 'right_top', 'left_middle', 'right_middle', 'left_down', 'right_down'}
  if ps == 1 then position = {'left_middle', 'right_middle'} end
  if ps == 2 then position = {'top', 'down'} end
  for _, i in pairs(position) do
    if #(GetOffsetFromEntityInWorldCoords(patient, target_offset[currentpose][i][1]) - GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -1.0)) < d then
      d = #(GetOffsetFromEntityInWorldCoords(patient, target_offset[currentpose][i][1]) - GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -1.0))
      close_position = GetOffsetFromEntityInWorldCoords(patient, target_offset[currentpose][i][1])  
      h = i
    end
  end
  return close_position, h
end

function GetCurrentPose()
  if IsEntityPlayingAnim(patient, poses[9][1], poses[9][2],   1) then currentpose = "back_side" end
  if IsEntityPlayingAnim(patient, poses[10][1], poses[10][2], 1) then currentpose = "front_side" end
  if IsEntityPlayingAnim(patient, poses[11][1], poses[11][2], 1) then currentpose = "left_side" end
  if IsEntityPlayingAnim(patient, poses[12][1], poses[12][2], 1) then currentpose = "right_side" end
  return currentpose
end

AddEventHandler("FirstAid", function()
	local ped = PlayerPedId()
  local _, _, _, _, target = GetShapeTestResult(StartShapeTestRay(GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -0.9),GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0), 4, ped, 0))
	
	if target == 0 and patient ~= nil and #(GetEntityCoords(patient) - GetEntityCoords(ped)) < 2 then target = patient end
	if target ~= 0 then patient = target else return end

  for j = 1, 2, 1 do
    RequestAnimDict(poses[j][1])
  end

  for j = 1, 2, 1 do
    local i = 1
    RequestAnimDict(poses[j][1])
    while not HasAnimDictLoaded(poses[j][1]) and i < 30 do
      i = i + 1
      Citizen.Wait(100)
    end	
    if not HasAnimDictLoaded(poses[j][1]) then return end
  end

  local close_pos_coords, close_pos = ClosePos()
  SetEntityHeading(ped, GetEntityHeading(patient) + target_offset[currentpose][close_pos][2] - 180)
  SetEntityCoords(ped, close_pos_coords.x, close_pos_coords.y, close_pos_coords.z - 1)
  TaskPlayAnim(ped, poses[1][1], poses[1][2], 8.0, 8.0, -1, 1, 0.0)  SetEntityHeading(ped, GetEntityHeading(ped) - 30) 
  Citizen.Wait(1500) 
  TaskPlayAnim(ped, poses[2][1], poses[2][2], 8.0, 8.0, -1, 1, 0.0)

  for j = 1, 2 do
    RemoveAnimDict(poses[j][1])
  end

end)

AddEventHandler("HealerPosition", function(args)
  local ped = PlayerPedId()
  local currentpose = GetCurrentPose()
  if patient == nil then return end
  
  local close_pos_coords = GetOffsetFromEntityInWorldCoords(patient, target_offset[currentpose][args][1])
  SetEntityCoords(ped, close_pos_coords.x, close_pos_coords.y, close_pos_coords.z - 1)
  SetEntityHeading(ped, GetEntityHeading(patient) + target_offset[currentpose][args][2] - 210)
  TaskPlayAnim(ped, poses[1][1], poses[1][2], 8.0, 8.0, -1, 1, 0.0)
  Citizen.Wait(1500)
  TaskPlayAnim(ped, poses[2][1], poses[2][2], 8.0, 8.0, -1, 1, 0.0)
end)

AddEventHandler("PatientRotation", function(args)
  local ped = PlayerPedId()
  local currentpose = GetCurrentPose()
  local anim_set
  local anim_heading
  local _, close_pos = ClosePos()

  if patient == nil then return end
  
  if args == "back_side" and currentpose ~= "back_side" then
    if currentpose == "front_side" then anim_set = {poses[3], poses[6], poses[9], poses[2]} anim_heading = {180, 0} end
    if currentpose == "left_side"  then anim_set = {poses[4], poses[7], poses[9], poses[2]} anim_heading = {0, 0} end
    if currentpose == "right_side" then anim_set = {poses[5], poses[8], poses[9], poses[2]} anim_heading = {90, 0} end
  elseif args == "front_side" and currentpose ~= "front_side" then
    if currentpose == "back_side"  then anim_set = {poses[3], poses[6], poses[10], poses[2]} anim_heading = {0, 180} end
    if currentpose == "left_side"  then anim_set = {poses[4], poses[7], poses[10], poses[2]} anim_heading = {-45, 180} end
    if currentpose == "right_side" then anim_set = {poses[5], poses[8], poses[10], poses[2]} anim_heading = {90, 180} end
  elseif args == "left_side" and currentpose ~= "left_side" then
    if currentpose == "front_side" then anim_set = {poses[4], poses[7], poses[11], poses[2]} anim_heading = {180, 45} end
    if currentpose == "back_side"  then anim_set = {poses[3], poses[6], poses[11], poses[2]} anim_heading = {0, 45} end
    if currentpose == "right_side" then anim_set = {poses[5], poses[8], poses[11], poses[2]} anim_heading = {45, 90} end
  elseif args == "right_side" and currentpose ~= "right_side" then
    if currentpose == "front_side" then anim_set = {poses[5], poses[8], poses[12], poses[2]} anim_heading = {180, -90} end
    if currentpose == "back_side"  then anim_set = {poses[3], poses[6], poses[12], poses[2]} anim_heading = {-90, -90} end
    if currentpose == "left_side"  then anim_set = {poses[4], poses[7], poses[12], poses[2]} anim_heading = {-45, -90} end
  else
    return
  end

  for j = 1, 4, 1 do
    local i = 1
    RequestAnimDict(anim_set[j][1])
    while not HasAnimDictLoaded(anim_set[j][1]) and i < 30 do
      i = i + 1
      Citizen.Wait(100)
    end	
    if not HasAnimDictLoaded(anim_set[j][1]) then return end
  end

  SetEntityHeading(patient, GetEntityHeading(patient) + anim_heading[1])

  TaskPlayAnim(ped, anim_set[1][1], anim_set[1][2], 8.0, 8.0, -1, 0, 0.0)
  TaskPlayAnim(patient, anim_set[2][1], anim_set[2][2], 8.0, 8.0, -1, 0, 0.0)
  Citizen.Wait(2000)

  SetEntityHeading(patient, GetEntityHeading(patient) + anim_heading[2])
  TaskPlayAnim(patient, anim_set[3][1], anim_set[3][2], 8.0, 8.0, -1, 1, 0.0)

  Citizen.Wait(100)
  local _, close_pos = ClosePos()
  TriggerEvent("HealerPosition", close_pos)
  TaskPlayAnim(ped, anim_set[4][1], anim_set[4][2], 8.0, 8.0, -1, 1, 0.0)
  SetEntityHeading(ped, GetEntityHeading(ped) + 30)
  for j = 1, 4, 1 do
    RemoveAnimDict(anim_set[j][1])
  end
end)

AddEventHandler("Action", function(args)
  local ped = PlayerPedId()
  local currentpose = GetCurrentPose()
  if patient == nil then return end
  
  local animset
  local _, close_pos = ClosePos(1)
  if args == "CPR" then anim_set = {actions[1], actions[2], poses[2], poses[9]} TriggerEvent("PatientRotation", "back_side") TriggerEvent("HealerPosition", close_pos) SetEntityHeading(ped, GetEntityHeading(ped) + 60) end

  for k, v in pairs(anim_set) do
    local i = 1
    RequestAnimDict(anim_set[k][1])
    while not HasAnimDictLoaded(anim_set[k][1]) and i < 30 do
      i = i + 1
      Citizen.Wait(100)
    end	
    if not HasAnimDictLoaded(anim_set[k][1]) then return end
  end

  TaskPlayAnim(ped, anim_set[1][1], anim_set[1][2], 8.0, 8.0, -1, 1, 0.0)
  TaskPlayAnim(patient, anim_set[2][1], anim_set[2][2], 8.0, 8.0, -1, 1, 0.0)

  Citizen.Wait(10000)

  TaskPlayAnim(ped, anim_set[3][1], anim_set[3][2], 8.0, 8.0, -1, 1, 0.0)
  TaskPlayAnim(patient, anim_set[4][1], anim_set[4][2], 8.0, 8.0, -1, 1, 0.0)

  for k, v in pairs(anim_set) do
    RemoveAnimDict(anim_set[k][1])
  end
end)

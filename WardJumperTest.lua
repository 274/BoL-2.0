if myHero.charName == "Katarina" or myHero.charName == "LeeSin" or myHero.charName == "Jax" then






if myHero.charName == "Jax" then
	GlobalJumpAbility = _Q
	JumpAbilityRange = 600
end
if myHero.charName == "LeeSin" then
	GlobalJumpAbility = _W
	JumpAbilityRange = 600
end
if myHero.charName == "Katarina" then
	GlobalJumpAbility = _E
	JumpAbilityRange = 600
end
local Wards = {}
local LastJump = 0
local Jumped = false
local LastPlacedObject = 0
function WardJump(x,y)
	local PlacedObj = false
	local JumpTarget = nil
	if Menu.JumpKey and LastJump+2000 < GetTickCount() and not Jumped then
		local jumpTo = Point(0,0)
		if x ~= nil and y ~= nil then
			jumpTo = GetDistance(Point(x,y)) < JumpAbilityRange and Point(x, y) or Point(myHero.x, myHero.z)-(Point(myHero.x, myHero.z)-Point(x, y)):normalized()*JumpAbilityRange
		else
			jumpTo = GetDistance(mousePos) < JumpAbilityRange and Point(mousePos.x, mousePos.z) or Point(myHero.x, myHero.z)-(Point(myHero.x, myHero.z)-Point(mousePos.x, mousePos.z)):normalized()*JumpAbilityRange
		end
		table.sort(Wards, function(a,b) return GetDistance(a) < GetDistance(b) end)
		for i, Ward in pairs(Wards) do
			if Ward == nil or not Ward.valid or Ward.dead then
				table.remove(Wards, i)
				i = i - 1
			else
				if Ward ~= nil and Ward.health > 0 and Ward.valid then
					if GetDistance(Ward, jumpTo) <= Menu.maxdistance then
						JumpTarget = Ward
					end	
				end
			end
		end	
		if JumpTarget ~= nil then
			if myHero:CanUseSpell(GlobalJumpAbility) == READY then
				CastSpellEx(GlobalJumpAbility, JumpTarget)
				Jumped = true
				LastJump = GetTickCount()
			end
		else
			if PlacedObj == false and LastPlacedObject+2000 < GetTickCount() and myHero:CanUseSpell(GlobalJumpAbility) == READY then
				local JumpingSlot = nil
				if GetInventorySlotItem(2045) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2045)) == READY then
					JumpingSlot = GetInventorySlotItem(2045)
				elseif GetInventorySlotItem(2049) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2049)) == READY then
					JumpingSlot = GetInventorySlotItem(2049)
				elseif myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3340 or myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3350 or myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3361 or myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3362 then
					JumpingSlot = ITEM_7
				elseif GetInventorySlotItem(2044) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2044)) == READY then
					JumpingSlot = GetInventorySlotItem(2044)
				elseif GetInventorySlotItem(2043) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2043)) == READY then
					JumpingSlot = GetInventorySlotItem(2043)
				end
				if JumpingSlot ~= nil then
					CastSpell(JumpingSlot, jumpTo.x, jumpTo.y)
					PlacedObj = true
					LastPlacedObject = GetTickCount()
				end
			end
		end
	else
		Jumped = false
		JumpTarget = nil
		PlacedObj = false
	end
end
function OnTick()
	WardJump()
end
function OnDraw()
	if Menu.drawJumpRange then DrawCircle(myHero.x, myHero.y, myHero.z, 600, RGB(0,191,255)) end
	if Menu.drawPlacedRange and Menu.JumpKey and Menu.maxdistance ~= 0 then
		local jumpTo = GetDistance(mousePos) < JumpAbilityRange and Point(mousePos.x, mousePos.z) or Point(myHero.x, myHero.z)-(Point(myHero.x, myHero.z)-Point(mousePos.x, mousePos.z)):normalized()*JumpAbilityRange
		DrawCircle(jumpTo.x, mousePos.y, jumpTo.y, Menu.maxdistance, RGB(0,191,255))
	end
end
function OnLoad()
	Menu = scriptConfig("aJumper v"..versionGOE, "ajumper")
	Menu:addParam("Information", "Enjoy and report bugs on forums!", SCRIPT_PARAM_INFO, "")
	Menu:addParam("Information2", "Created by Anonymous :)", SCRIPT_PARAM_INFO, "")
	Menu:addParam("drawJumpRange","Draw jump range", SCRIPT_PARAM_ONOFF, false)
	Menu:addParam("maxdistance","Maximum distance to jump", SCRIPT_PARAM_SLICE, 200, 0, 500, 0)
	Menu:addParam("Information3", "at wards placed already/creeps.", SCRIPT_PARAM_INFO, "")
	Menu:addParam("drawPlacedRange","Draw detection range", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("JumpKey","Jump key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
	Menu.JumpKey = false
end
function OnCreateObj(obj)
	if obj ~= nil and obj.valid then
		if obj.name == "SightWard" or obj.name == "VisionWard" then
			table.insert(Wards, obj)
		end
	end
end 
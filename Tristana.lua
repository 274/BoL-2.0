--[[
 ----------------------------------------------------------------------------
 "THE BEER-WARE LICENSE" (Revision 42):
 Greeny and fROMAGE wrote this file. As long as you retain this notice
 you can do whatever you want with this stuff (exept sell it).
 If we meet some day, and you think this stuff
 is worth it, you can buy us a beer in return 
 ----------------------------------------------------------------------------
]]

Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)

function OnStart()
	if player.charName ~= 'Tristana' then return end

		TheMenu = MenuConfig("Tristana")
		TheMenu:Icon("fa-user")

		TheMenu:Menu("Combo", "Combo Settings")
		TheMenu.Combo:Icon("fa-folder-o")
		TheMenu.Combo:Section("Combo Settings", "Combo Settings")
		TheMenu.Combo:Boolean("useq", "Use Q", true)
		TheMenu.Combo:Boolean("usee", "Use E", true)
		TheMenu.Combo:Boolean("user", "Use R", true)

		TheMenu:Menu("Harass", "Harass Settings")
		TheMenu.Harass:Icon("fa-folder-o")
		TheMenu.Harass:Section("Harass Settings", "Harass Settings")  
		TheMenu.Harass:Boolean("usee", "Use E", true)

		TheMenu:Menu("LaneClear", "Lane Clear Settings")
		TheMenu.LaneClear:Icon("fa-folder-o")
		TheMenu.LaneClear:Section("LaneClear Settings", "Lane Clear Settings")  
		TheMenu.LaneClear:Boolean("useq", "Use Q", false)

		TheMenu:Menu("KS", "KS Settings")
		TheMenu.KS:Icon("fa-folder-o")
		TheMenu.KS:Section("KS Settings", "KS Settings")
		TheMenu.KS:Boolean("usee", "Use E", false)
		TheMenu.KS.usee:Note("I recommend you to turn it to true only if you're playing AP Tristana.")
		TheMenu.KS:Boolean("user", "Use R", true)

		TheMenu:Menu("Items", "Item Settings")
		TheMenu.Items:Icon("fa-folder-o")
		TheMenu.Items:Section("Item Settings", "Item Settings")
		TheMenu.Items:Boolean("usedfg", "Use Deathfire Grasp", true)
		TheMenu.Items:Boolean("usebt", "Use Blackfire Torch", true)
		TheMenu.Items:Boolean("usehg", "Use Hextech Gunblade", true)
		TheMenu.Items:Boolean("usebc", "Use Bilgewater Cutlass", true) 
		TheMenu.Items:Section("Advanced", "Advanced")  
		TheMenu.Items:Boolean("usez", "Auto Zhonya's", true)

		TheMenu:Section('Keys', 'Keys Selection')
		TheMenu:KeyBinding('combokey', 'Combo', 'Space')
		TheMenu:KeyBinding('harasskey', 'Harass', 'A')
		TheMenu.harasskey:Toggle('Toggle-Mode')
		TheMenu:KeyBinding('laneclearkey', 'Lane Clear', 'X')
		TheMenu:DropDown("is_magic_or_physical", 'AD or AP', 1, {"AD", "AP"})

	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('ProcessSpell', function(unit, spell) OnProcessSpell(unit, spell) end)

	Game.Chat.Print("<font color=\"#F5F5F5\">[Tristana] by me (me ! remember ??) loaded! </font>")

end

function GetTarget(range, magic_or_physical)
	local T = {Unit = nil, THP = 100000}
	for i = 1, Game.HeroCount() do
		local h = Game.Hero(i)
		if h and h.valid and h.visible and not h.dead and h.isTargetable and h.team ~= myHero.team and h.pos:DistanceTo(myHero.pos) < myhero.range then
			local THP = (h.health * (1 + ((magic_or_physical and h.magicArmor or h.armor) / 100)))
			if THP < T.THP then	T.Unit, T.THP = h, THP end
		end	
	end
	return T.Unit
end


function OnTick()

	Checks()
	Combo()
	Harass()
	LaneClear()
	KS()
	Items()

end

function Checks()

	magic_or_physical = 0;
	if TheMenu.is_magic_or_physical:Value() == 1 then
		magic_or_physical = false
	end
	if TheMenu.is_magic_or_physical:Value() == 2 then
		magic_or_physical = true
	end

	Target = GetTarget(GetRange(), magic_or_physical)

	Qready = player:CanUseSpell(0) == Game.SpellState.READY
	Wready = player:CanUseSpell(1) == Game.SpellState.READY
	Eready = player:CanUseSpell(2) == Game.SpellState.READY
	Rready = player:CanUseSpell(3) == Game.SpellState.READY

end

function ValidTarget(Target)
	return Target ~= nil and Target.type == player.type and Target.team == TEAM_ENEMY and not Target.dead and Target.visible and Target.health > 0 and Target.isTargetable
end

function OnProcessSpell(unit, spell)
	if unit.isMe and spell.name:find("Attack") then
		animationTime = 1 / (spell.animationTime * player.attackSpeed)
		windUpTime = 1 / (spell.windUpTime * player.attackSpeed)
	end
end

function GetItemSlot(id, unit)
	local unit = unit or player
	for i = 4, 9, 1 do
		if unit:GetItem(i) and unit:GetItem(i).id == id then
			return i
		end
	end
end

function GetRange()
    return 541 + 9 * player.level;
end

function Combo()

    if TheMenu.combokey:IsPressed() then

    	if ValidTarget(Target) then

			local target_distance = Allclass.GetDistance(Target)

            if target_distance < myhero.range and Qready then
            	player:CastSpell(0)
            end

            if target_distance < GetRange() and Eready then 
                player:CastSpell(2, Target)
            end

        end

    end

end

function Harass()

	if Tristana.harasskey:IsPressed() then

	 	if ValidTarget(Target) then

			local target_distance = Allclass.GetDistance(Target)

        	if target_distance < GetRange() and Eready then
                player:CastSpell(2, Target)
            end

        end

	end

end

function LaneClear()

	 if TheMenu.laneclearkey:IsPressed() then

		if ValidTarget(Target) then

			local target_distance = Allclass.GetDistance(Target)

            if Qready then
            	player:CastSpell(0)
            end

        end

    end

end

function KS()

	

end

function GetDistanceSqr(v1, v2)
	v2 = v2 or player
	return (v1.x - v2.x) ^ 2 + ((v1.z or v1.y) - (v2.z or v2.y)) ^ 2
end

function Autokill()
	for i = 1, Game.HeroCount() do
		hero = Game.Hero(i)

		local heroDistance = Allclass.GetDistanceSqr(hero)
		
		if heroDistance < 640000 and ValidTarget(hero) then

			local qdmg = player:CalcMagicDamage(hero, (20*player:GetSpellData(0).level+15+.4*player.ap))
			local edmg = player:CalcMagicDamage(hero, (25*player:GetSpellData(2).level+5+0.3*player.ap+0.6*player.totalDamage))
			local rdmg = player:CalcMagicDamage(hero, (75*player:GetSpellData(3).level+25+.5*player.ap))

			if Qready and hero.health < qdmg and heroDistance < 360000 and Tristana.Ks.useq:Value() then
				player:CastSpell(0, hero)
			

			elseif Eready and hero.health < edmg and heroDistance < 105625 and Tristana.Ks.usee:Value() then
				player:CastSpell(2, hero)
			

			elseif Rready and heroDistance < 640000 and Tristana.Ks.user:Value() then
				if hero.health < rdmg then
					player:CastSpell(3, hero)

				elseif Eready and hero.health < (rdmg+edmg) and Tristana.Ks.usee:Value() then
					player:CastSpell(3, hero)

				end
			end
		end
	end
end

function OnDraw()
	
	if Tristana.Draw.Colors:Value() == 1 then 
		Farbe = Color.Red
	elseif Tristana.Draw.Colors:Value() == 2 then
		Farbe = Color.Green
	elseif Tristana.Draw.Colors:Value() == 3 then
		Farbe = Color.Blue
	elseif Tristana.Draw.Colors:Value() == 4 then
		Farbe = Color.White
	end
	
	if Tristana.Draw.Enable:Value() then
		if (Tristana.Draw.draww:Value()) then
			Graphics.DrawCircle(player, 900, Farbe)
		end
		if (Tristana.Draw.drawe:Value()) then
			Graphics.DrawCircle(player, GetRange(), Farbe)
		end
		if (Tristana.Draw.drawr:Value()) then
			Graphics.DrawCircle(player, GetRange(), Farbe)
		end
	end
end
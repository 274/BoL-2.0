--[[
 ----------------------------------------------------------------------------
 "THE BEER-WARE LICENSE" (Revision 42):
 Greeny and fROMAGE wrote this file. As long as you retain this notice
 you can do whatever you want with this stuff (exept sell it).
 If we meet some day, and you think this stuff
 is worth it, you can buy us a beer in return 
 ----------------------------------------------------------------------------
]]


local TS = TargetSelector(TargetSelector_Mode.LESS_CAST, TargetSelector_DamageType.MAGIC) 


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
		TheMenu.Items:Slider("hz", "Zhonya's if Health under -> %", 10, 0, 100)

		TheMenu:Section('Keys', 'Keys Selection')
		TheMenu:KeyBinding('combokey', 'Combo', 'Space')
		TheMenu:KeyBinding('harasskey', 'Harass', 'A')
		TheMenu.harasskey:Toggle('Toggle-Mode')
		TheMenu:KeyBinding('laneclearkey', 'Lane Clear', 'X')

	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('ProcessSpell', function(unit, spell) OnProcessSpell(unit, spell) end)

	Game.Chat.Print("<font color=\"#F5F5F5\">[Tristana] by me (me ! remember ??) loaded! </font>")

end

function OnTick()

	Checks()
	Combo()
	Orbwalk()
	Autokill()

	Harass()

	AA()

end

function Checks()

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
    if ValidTarget(Target) then
        local tdis      = Allclass.GetDistance(Target)
        local onlyeq    = menu.Combo.onlyeq:Value()

        if menu.combokey:IsPressed() then
            if tdis < GetRange() and Eready then 
                player:CastSpell(2, Target)

            elseif tdis < player:range() and Qready then 
                player:CastSpell(0)

        elseif menu.Combo:Value() then
            if tdis < GetRange() and Eready then 
                player:CastSpell(2, Target)
        	end

        elseif menu.laneclearkey:IsPressed() then
            if Qready then
            	player:CastSpell(0)
        end
    end
end

function Harass()
	if Tristana.harasskey:IsPressed() then

		if ValidTarget(Target) then

			if Tristana.Harass.useq:Value() and Allclass.GetDistance(Target) < 600 and Qready then
			player:CastSpell(0, Target)
			end

		end
	end
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
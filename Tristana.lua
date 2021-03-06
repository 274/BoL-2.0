--[[
 ----------------------------------------------------------------------------
 "THE BEER-WARE LICENSE" (Revision 42):
 Greeny and fROMAGE wrote this file. As long as you retain this notice
 you can do whatever you want with this stuff (exept sell it).
 If we meet some day, and you think this stuff
 is worth it, you can buy us a beer in return 
 ----------------------------------------------------------------------------
]]


-- Version : 1.0.0.42

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

		TheMenu:Menu("draw", "Draw")
		TheMenu.draw:Boolean("drawrange", "Draw Range ?", true)
		TheMenu.draw:Boolean("draww", "Draw W Range ?", true)

--[[		TheMenu:Menu("Items", "Item Settings")
		TheMenu.Items:Icon("fa-folder-o")
		TheMenu.Items:Section("Item Settings", "Item Settings")
		TheMenu.Items:Boolean("usedfg", "Use Deathfire Grasp", true) ]]

		TheMenu:Section('Keys', 'Keys Selection')
		TheMenu:KeyBinding('combokey', 'Combo', 'SPACE')
		TheMenu:KeyBinding('harasskey', 'Harass', 'A')
		TheMenu.harasskey:Toggle('Toggle-Mode')
		TheMenu:Boolean('kskey', 'KS', true)
		TheMenu:KeyBinding('laneclearkey', 'Lane Clear', 'X')
		TheMenu:DropDown("is_magic_or_physical", 'AD or AP', 1, {"AD", "AP"})


	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('Draw', function() OnDraw() end)

	Game.Chat.Print("<font color=\"#F5F5F5\">[Tristana] by me (me ! remember ??) loaded! </font>")

	Color = { Red = Graphics.ARGB(0xFF,0xFF,0,0),
			  Green = Graphics.ARGB(0xFF,0,0xFF,0),
			  Blue = Graphics.ARGB(0xFF,0,0,0xFF),
			  White = Graphics.ARGB(0xFF,0xFF,0xFF,0xFF),
			  Yellow = Graphics.ARGB(0xFF,0xFF,0xFF,0)
			}

end

function GetTarget(range, magic_or_physical)
	local T = {Unit = nil, THP = 100000}
	for i = 1, Game.HeroCount() do
		local h = Game.Hero(i)
		if h and h.valid and h.visible and not h.dead and h.isTargetable and h.team ~= myHero.team and h.pos:DistanceTo(myHero.pos) < player.range then
			local THP = (h.health * (1 + ((magic_or_physical and h.magicArmor or h.armor) / 100)))
			if THP < T.THP then	T.Unit, T.THP = h, THP end
		end	
	end
	return T.Unit
end


function OnTick()

	Checks()
	KS()
	Combo()
	Harass()
	LaneClear()

end

function Checks()

	magic_or_physical = 0;
	if TheMenu.is_magic_or_physical:Value() == 1 then
		magic_or_physical = false
	end
	if TheMenu.is_magic_or_physical:Value() == 2 then
		magic_or_physical = true
	end

	Target = GetTarget(player.range, magic_or_physical)

	Qready = player:CanUseSpell(0) == Game.SpellState.READY
	Wready = player:CanUseSpell(1) == Game.SpellState.READY
	Eready = player:CanUseSpell(2) == Game.SpellState.READY
	Rready = player:CanUseSpell(3) == Game.SpellState.READY

end

function ValidTarget(Target)
	return Target ~= nil and Target.type == player.type and Target.team == TEAM_ENEMY and not Target.dead and Target.visible and Target.health > 0 and Target.isTargetable
end

function Combo()

	if TheMenu.combokey:IsPressed() then
		if ValidTarget(Target) then
			
			local target_distance = Allclass.GetDistance(Target)

			if target_distance < player.range and Qready then
				player:CastSpell(0)
				Qready = false
			end

			if target_distance < player.range and Eready then 
				player:CastSpell(2, Target)
				Eready = false
			end
		end
	end
end

function Harass()

	if TheMenu.harasskey:IsPressed() then
			 		Game.Chat.Print("<font color=\"#F5F5F5\">harass </font>")

	 	if ValidTarget(Target) then

			local target_distance = Allclass.GetDistance(Target)

			if target_distance < player.range and Eready then
				player:CastSpell(2, Target)
				Eready = false
			end
		end
	end
end

function LaneClear()

	 if TheMenu.laneclearkey:IsPressed() then
	 		Game.Chat.Print("<font color=\"#F5F5F5\">Lane Clear </font>")

		if Qready then
			player:CastSpell(0)
			Qready = false
		end
	end
end

function KS()

	if TheMenu.kskey:Value() then

		for i = 1, Game.HeroCount() do

			ennemi = Game.Hero(i)

			local ennemi_distance = Allclass.GetDistance(ennemi)

			if ValidTarget(ennemi) and ennemi_distance < player.range then

				local edmg = player:CalcMagicDamage(ennemi, 25 + 25 * player:GetSpellData(2).level + 0.25 * player.ap) -- burst dmg only
				local rdmg = player:CalcMagicDamage(ennemi, 200 + 100 * player:GetSpellData(3).level + 1.5 * player.ap)

				if Eready and ennemi.health < edmg - 30 and TheMenu.KS.usee:Value() then
					player:CastSpell(2, ennemi)
					Eready = false

				elseif Rready and ennemi.health < rdmg - 30 and TheMenu.KS.user:Value() then
					player:CastSpell(3, ennemi)
					Rready = false

				elseif Eready and Rready and ennemi.health < edmg + rdmg - 30 and TheMenu.KS.user:Value() and TheMenu.KS.usee:Value() then
					player:CastSpell(2, ennemi)
					player:CastSpell(3, ennemi)
					Eready = false
					Rready = false
				end
			end
		end
	end
end

function CanCastSpell(spell, target)
	if player:CanUseSpell(spell) == Game.SpellState.READY and player:DistanceTo(target) < player:GetSpellData(spell).range then
		return true
	else 
		return false
	end
end


function OnDraw()
	
	if TheMenu.combokey:IsPressed() then
		CircleColor = Color.Red
	elseif TheMenu.harasskey:IsPressed() then
		CircleColor = Color.Yellow
	elseif TheMenu.laneclearkey:IsPressed() then
		CircleColor = Color.Green
	else
		CircleColor = Color.White
	end

	if TheMenu.draw.draww:Value() then
		Graphics.DrawCircle(player, myHero:GetSpellData(1).range, CircleColor)
	end

	if TheMenu.draw.drawrange:Value() then
		Graphics.DrawCircle(player, player.range, CircleColor)
	end
end 
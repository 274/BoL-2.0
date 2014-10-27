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

--[[		TheMenu:Menu("Items", "Item Settings")
		TheMenu.Items:Icon("fa-folder-o")
		TheMenu.Items:Section("Item Settings", "Item Settings")
		TheMenu.Items:Boolean("usedfg", "Use Deathfire Grasp", true)
		TheMenu.Items:Boolean("usebt", "Use Blackfire Torch", true)
		TheMenu.Items:Boolean("usehg", "Use Hextech Gunblade", true)
		TheMenu.Items:Boolean("usebc", "Use Bilgewater Cutlass", true) 
		TheMenu.Items:Section("Advanced", "Advanced")  
		TheMenu.Items:Boolean("usez", "Auto Zhonya's", true) ]]

		TheMenu:Section('Keys', 'Keys Selection')
		TheMenu:KeyBinding('combokey', 'Combo', 'V')
		TheMenu:KeyBinding('harasskey', 'Harass', 'A')
		TheMenu.harasskey:Toggle('Toggle-Mode')
		TheMenu:Boolean('kskey', 'KS', true)
		TheMenu:KeyBinding('laneclearkey', 'Lane Clear', 'X')
		TheMenu:DropDown("is_magic_or_physical", 'AD or AP', 1, {"AD", "AP"})


	Callback.Bind('Tick', function() OnTick() end)

	Game.Chat.Print("<font color=\"#F5F5F5\">[Tristana] by me (me ! remember ??) loaded! </font>")

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
			if player:distanceTo(target) < player.range and Qready then
				player:CastSpell(0)
				Qready = false
			end

			if player:distanceTo(target) < player.range and Eready then 
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

function KS()

	if TheMenu.kskey:Value() then

		for i = 1, Game.HeroCount() do

			ennemi = Game.Hero(i)
			if ValidTarget(ennemi) and player:distanceTo(ennemi) < player.range then

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

--[[
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
			Graphics.DrawCircle(player, player.range, Farbe)
		end
		if (Tristana.Draw.drawr:Value()) then
			Graphics.DrawCircle(player, player.range, Farbe)
		end
	end
end ]]
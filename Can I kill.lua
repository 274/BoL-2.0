	--[[
	 
	 ██████╗ █████╗ ███╗   ██╗	██╗	██╗  ██╗██╗██╗	 ██╗		 ██╗  ██╗██╗███╗   ███╗██████╗
	██╔════╝██╔══██╗████╗  ██║	██║	██║ ██╔╝██║██║	 ██║		 ██║  ██║██║████╗ ████║╚════██╗
	██║	 ███████║██╔██╗ ██║	██║	█████╔╝ ██║██║	 ██║		 ███████║██║██╔████╔██║  ▄███╔╝
	██║	 ██╔══██║██║╚██╗██║	██║	██╔═██╗ ██║██║	 ██║		 ██╔══██║██║██║╚██╔╝██║  ▀▀══╝
	╚██████╗██║  ██║██║ ╚████║	██║	██║  ██╗██║███████╗███████╗	██║  ██║██║██║ ╚═╝ ██║  ██╗  
	 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝	╚═╝	╚═╝  ╚═╝╚═╝╚══════╝╚══════╝	╚═╝  ╚═╝╚═╝╚═╝	 ╚═╝  ╚═╝  
	 
	Author: Mr Slave (ported to 2.0 by Green Death and fROMAGE)
	Version: 2.0
	 
	Thanks to: Roach ( dmg indicator )
	 
	 
	]]
	 
	 
	 
Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)
	 
	function OnStart()
	
		TheMenu = MenuConfig("Can I kill him ?")
		TheMenu:Icon("fa-user")

		TheMenu:Boolean("drawtext", "Draw text on ennemy ?", true)
		TheMenu:Section("enemy", "Ennemy champions")

		for i = 1, Game.HeroCount() do
			local hero = Game.Hero(i)
			if hero and hero.valid and hero.team ~= myHero.team then
				TheMenu:Boolean(hero.charName, "Draw for: " .. hero.charName .. "?", true)
			end
		end
		 
		Callback.Bind('Tick', function() OnTick() end)
		Callback.Bind('Draw', function() OnDraw() end)

		Game.Chat.Print("<font color=\"#F5F5F5\">[Can I kill him ?] by Mr Slave loaded! </font>")
	 
	end

	function ValidTarget(Target)
		return Target ~= nil and Target.type == player.type and Target.team ~= myHero.team and not Target.dead and Target.visible and Target.health > 0 and Target.isTargetable
	end

	function OnTick()
	
		for i = 1, Game.HeroCount() do
			local enemy = Game.Hero(i)
			if ValidTarget(enemy)  
				SpellQ = SpellDamage.GetDamage(0, enemy, myHero)
				SpellW = SpellDamage.GetDamage(1, enemy, myHero)
				SpellE = SpellDamage.GetDamage(2, enemy, myHero)
				SpellR = SpellDamage.GetDamage(3, enemy, myHero)
				--SpellI = SpellDamage.GetDamage("IGNITE", enemy, myHero)

			   
				if enemy.health < SpellR then
					indicatorText[i] = "R Kill"
					   
				elseif enemy.health < SpellQ then
					indicatorText[i] = "Q Kill"
					   
				elseif enemy.health < SpellW then
					indicatorText[i] = "W Kill"
					   
				elseif enemy.health < SpellE then
					indicatorText[i] = "E Kill"
			   
				elseif enemy.health < SpellQ + SpellW then
					indicatorText[i] = "Q + W Kill"

				elseif enemy.health < SpellQ + SpellE then
					indicatorText[i] = "Q + E Kill"

				elseif enemy.health < SpellW + SpellE then
					indicatorText[i] = "W + E Kill"

				elseif enemy.health < SpellQ + SpellW + SpellE then
					indicatorText[i] = "Q + W + E Kill"

				elseif enemy.health < SpellQ + SpellR then
					indicatorText[i] = "Q + R Kill"
			   
				elseif enemy.health < SpellW + SpellR then
					indicatorText[i] = "W + R Kill"
					   
				elseif enemy.health < SpellE + SpellR then
					indicatorText[i] = "E + R Kill"
			   
				elseif enemy.health < SpellQ + SpellW + SpellR then
					indicatorText[i] = "Q + W + R Kill"
					   
				elseif enemy.health < SpellQ + SpellE + SpellR then
					indicatorText[i] = "Q + E + R Kill"

				elseif enemy.health < SpellW + SpellE + SpellR then
					indicatorText[i] = "W + E + R Kill"
					   
				else
					local dmgTotal = (SpellQ + SpellW + SpellE + SpellR)
					local hpLeft = math.round(enemy.health - dmgTotal)
					local percentLeft = math.round(hpLeft / enemy.maxHealth * 100)

					indicatorText[i] =  percentLeft .. "% left !"
				end

			--[[	local myAD = getDmg("AD", enemy, myHero)
		 
				damageGettingText[i] = "I kill " .. enemy.charName .. " with " .. math.ceil(enemy.health / myAD) .. " hits" ]]
			   
				-- Thanks to Roach
			end
		end
	end
	 
	 
	 
	function OnDraw()																								
		if TheMenu.drawtext:Value() then				
			for i = 1, Game.HeroCount() do
				local enemy = Game.Hero(i)
				if ValidTarget(enemy) and TheMenu.drawing.enemy.charName == true then
					local barPos = Game.GetUnitHPBarPos(enemy)
					local pos = { X = barPos.x - 35, Y = barPos.y - 50 }
											   
					--Roach
					Graphics.DrawText(indicatorText[i], 15, pos.X + 20, pos.Y, ARGB(255, 0, 255, 0))
				--	Graphics.DrawText(enemyTable[i].damageGettingText, 15, pos.X + 20, pos.Y + 15, ARGB(255, 255, 0, 0))
				end	   
			end
		end			
	 end
	   
	 
	 


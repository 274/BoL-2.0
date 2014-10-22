local TS = TargetSelector(TargetSelector_Mode.LESS_CAST, TargetSelector_DamageType.MAGIC) 


Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)

function OnStart()
	if myHero.charName ~= 'Tristana' then return end

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

	lastAttack = 0
    windUpTime = 3
    animationTime = 0.65


	Game.Chat.Print("<font color=\"#F5F5F5\">[Awesome Tristana] by DeadDevil2 loaded! </font>")

end

function OnTick()

	if Tristana.Adds.Orbwalk:Value() == 1 then
		Target = TS:GetTarget(800)

	elseif Tristana.Adds.Orbwalk:Value() == 2 then 
		Target = SxOrb:GetTarget()
		SxOrb:EnableAttacks()
	end

	Checks()
	Combo()
	Orbwalk()
	Autokill()
	Autostealth()
	Harass()
	Items()
	Autozhonya()
	AA()

end

function Checks()

	Qready = myHero:CanUseSpell(0) == Game.SpellState.READY
	Wready = myHero:CanUseSpell(1) == Game.SpellState.READY
	Eready = myHero:CanUseSpell(2) == Game.SpellState.READY
	Rready = myHero:CanUseSpell(3) == Game.SpellState.READY

end

function ValidTarget(Target)
	return Target ~= nil and Target.type == myHero.type and Target.team == TEAM_ENEMY and not Target.dead and Target.visible and Target.health > 0 and Target.isTargetable
end


function TargetHasBuff(unit, name)
	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and buff.name == name and buff.startT <= Game.ServerTimer() and buff.endT >= Game.ServerTimer() then
			return true
		end
	end
	return false
end


function AA()

	if ValidTarget(Target) then

	AAdis	=	Allclass.GetDistance(Target) < 525 

	if AAdis and Tristana.Adds.Orbwalk:Value() == 1 then
	Orbwalk(Target)
	end

	end
end


function OnProcessSpell(unit, spell)
	if unit.isMe and spell.name:find("Attack") then
		animationTime = 1 / (spell.animationTime * myHero.attackSpeed)
		windUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
	end
end


function GetItemSlot(id, unit)
	local unit = unit or myHero
	for i = 4, 9, 1 do
		if unit:GetItem(i) and unit:GetItem(i).id == id then
			return i
		end
	end
end


function CastItem(ItemID, var1, var2)
	local slot = GetItemSlot(ItemID)
	if slot == nil then return end
	if (myHero:CanUseSpell(slot) == Game.SpellState.READY) then
		if (var2 ~= nil) then
			myHero:CastSpell(slot, var1, var2)
		elseif (var1 ~= nil) then
			myHero:CastSpell(slot, var1)
		else
			myHero:CastSpell(slot)
		end
	end
end


function Items()

	if ValidTarget(Target) and Tristana.combokey:IsPressed() then

	local tdis	=	Allclass.GetDistance(Target)

		if Tristana.Items.usedfg:Value() 	and 	tdis < 750 then CastItem(3128, Target) end
		if Tristana.Items.usebt:Value() 	and 	tdis < 750 then CastItem(3188, Target) end
		if Tristana.Items.usehg:Value() 	and 	tdis < 700 then CastItem(3146, Target) end
		if Tristana.Items.usebc:Value() 	and 	tdis < 700 then CastItem(3144, Target) end

	end
end


function Combo()

	if ValidTarget(Target) then

	local tdis		=	Allclass.GetDistance(Target)
	local onlyeq	=	Tristana.Combo.onlyeq:Value()
	local hbuff 	=	TargetHasBuff(Target, "TristanaMota")

		if Tristana.combokey:IsPressed() and not Tristana.Combo.onlyriqe:Value() then

			if Tristana.Combo.useq:Value() and tdis < 600 and Qready then 
				myHero:CastSpell(0, Target)
			

			elseif Tristana.Combo.usee:Value() and tdis < 300 and Eready and not onlyeq then 
				myHero:CastSpell(2)
			

			elseif Tristana.Combo.usee:Value() and tdis < 300 and Eready and onlyeq and hbuff then 
				myHero:CastSpell(2)
		

			elseif Tristana.Combo.user:Value() and tdis < 800 and Rready then 
				myHero:CastSpell(3, Target)
			end

		elseif Tristana.combokey:IsPressed() and Tristana.Combo.onlyriqe:Value() then

			if (myHero.level < 6 or myHero:GetSpellData(0).currentCd < myHero:GetSpellData(3).currentCd) and Qready and tdis < 600 then
				myHero:CastSpell(0, Target)
			

			elseif (myHero.level < 6 or myHero:GetSpellData(2).currentCd < myHero:GetSpellData(3).currentCd) and hbuff and onlyeq and Eready and tdis < 300 then
				myHero:CastSpell(2)
			

			elseif (myHero.level < 6 or myHero:GetSpellData(2).currentCd < myHero:GetSpellData(3).currentCd) and not onlyeq and Eready and tdis < 300 then
				myHero:CastSpell(2)
			

			elseif Rready and Qready and Eready and tdis < 800 then
				myHero:CastSpell(3, Target)

				if tdis < 600 then
					myHero:CastSpell(0, Target)

					if tdis < 300 and hbuff then
						myHero:CastSpell(2)
					end
				end
			end
		end
	end
end


function Harass()
	if Tristana.harasskey:IsPressed() then

		if ValidTarget(Target) then

			if Tristana.Harass.useq:Value() and Allclass.GetDistance(Target) < 600 and Qready then
			myHero:CastSpell(0, Target)
			end

		end
	end
end


function CountEnemyHeroInRange(range,object)
	object = object or myHero
	range = range and range * range or myHero.range * myHero.range
	local enemyInRange = 0
	for i = 1, Game.HeroCount(), 1 do
		local hero = Game.Hero(i)
		if hero.team == TEAM_ENEMY and not hero.dead and GetDistanceSqr(object, hero) <= range then
			enemyInRange = enemyInRange + 1
		end
	end
	return enemyInRange
end

function GetDistanceSqr(v1, v2)
	v2 = v2 or player
	return (v1.x - v2.x) ^ 2 + ((v1.z or v1.y) - (v2.z or v2.y)) ^ 2
end

function Autostealth()
	if Tristana.Stealth.usew:Value() and Wready then
		if Tristana.Stealth.autow:Value() == 1 then
			if CountEnemyHeroInRange(700, myHero) >= 2 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		

		elseif Tristana.Stealth.autow:Value() == 2 then
			if CountEnemyHeroInRange(700, myHero) >= 3 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		

		elseif Tristana.Stealth.autow:Value() == 3 then
			if CountEnemyHeroInRange(700, myHero) >= 4 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		

		elseif Tristana.Stealth.autow:Value() == 4 then
			if CountEnemyHeroInRange(700, myHero) == 5 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		end
	end						
end

function Autozhonya()
	if Tristana.Items.usez:Value() then
		if myHero.health <= (myHero.maxHealth*(Tristana.Items.hz:Value()/100)) then CastItem(3157) CastItem(3090)
		end
	end
end

local hitboxes = {['Braum'] = 80, ['RecItemsCLASSIC'] = 65, ['TeemoMushroom'] = 50.0, ['TestCubeRender'] = 65, ['Xerath'] = 65, ['Kassadin'] = 65, ['Rengar'] = 65, ['Thresh'] = 55.0, ['RecItemsTUTORIAL'] = 65, ['Ziggs'] = 55.0, ['ZyraPassive'] = 20.0, ['ZyraThornPlant'] = 20.0, ['KogMaw'] = 65, ['HeimerTBlue'] = 35.0, ['EliseSpider'] = 65, ['Skarner'] = 80.0, ['ChaosNexus'] = 65, ['Katarina'] = 65, ['Riven'] = 65, ['SightWard'] = 1, ['HeimerTYellow'] = 35.0, ['Ashe'] = 65, ['VisionWard'] = 1, ['TT_NGolem2'] = 80.0, ['ThreshLantern'] = 65, ['RecItemsCLASSICMap10'] = 65, ['RecItemsODIN'] = 65, ['TT_Spiderboss'] = 200.0, ['RecItemsARAM'] = 65, ['OrderNexus'] = 65, ['Soraka'] = 65, ['Jinx'] = 65, ['TestCubeRenderwCollision'] = 65, ['Red_Minion_Wizard'] = 48.0, ['JarvanIV'] = 65, ['Blue_Minion_Wizard'] = 48.0, ['TT_ChaosTurret2'] = 88.4, ['TT_ChaosTurret3'] = 88.4, ['TT_ChaosTurret1'] = 88.4, ['ChaosTurretGiant'] = 88.4, ['Dragon'] = 100.0, ['LuluSnowman'] = 50.0, ['Worm'] = 100.0, ['ChaosTurretWorm'] = 88.4, ['TT_ChaosInhibitor'] = 65, ['ChaosTurretNormal'] = 88.4, ['AncientGolem'] = 100.0, ['ZyraGraspingPlant'] = 20.0, ['HA_AP_OrderTurret3'] = 88.4, ['HA_AP_OrderTurret2'] = 88.4, ['Tryndamere'] = 65, ['OrderTurretNormal2'] = 88.4, ['Singed'] = 65, ['OrderInhibitor'] = 65, ['Diana'] = 65, ['HA_FB_HealthRelic'] = 65, ['TT_OrderInhibitor'] = 65, ['GreatWraith'] = 80.0, ['Yasuo'] = 65, ['OrderTurretDragon'] = 88.4, ['OrderTurretNormal'] = 88.4, ['LizardElder'] = 65.0, ['HA_AP_ChaosTurret'] = 88.4, ['Ahri'] = 65, ['Lulu'] = 65, ['ChaosInhibitor'] = 65, ['HA_AP_ChaosTurret3'] = 88.4, ['HA_AP_ChaosTurret2'] = 88.4, ['ChaosTurretWorm2'] = 88.4, ['TT_OrderTurret1'] = 88.4, ['TT_OrderTurret2'] = 88.4, ['TT_OrderTurret3'] = 88.4, ['LuluFaerie'] = 65, ['HA_AP_OrderTurret'] = 88.4, ['OrderTurretAngel'] = 88.4, ['YellowTrinketUpgrade'] = 1, ['MasterYi'] = 65, ['Lissandra'] = 65, ['ARAMOrderTurretNexus'] = 88.4, ['Draven'] = 65, ['FiddleSticks'] = 65, ['SmallGolem'] = 80.0, ['ARAMOrderTurretFront'] = 88.4, ['ChaosTurretTutorial'] = 88.4, ['NasusUlt'] = 80.0, ['Maokai'] = 80.0, ['Wraith'] = 50.0, ['Wolf'] = 50.0, ['Sivir'] = 65, ['Corki'] = 65, ['Janna'] = 65, ['Nasus'] = 80.0, ['Golem'] = 80.0, ['ARAMChaosTurretFront'] = 88.4, ['ARAMOrderTurretInhib'] = 88.4, ['LeeSin'] = 65, ['HA_AP_ChaosTurretTutorial'] = 88.4, ['GiantWolf'] = 65.0, ['HA_AP_OrderTurretTutorial'] = 88.4, ['YoungLizard'] = 50.0, ['Jax'] = 65, ['LesserWraith'] = 50.0, ['Blitzcrank'] = 80.0, ['brush_D_SR'] = 65, ['brush_E_SR'] = 65, ['brush_F_SR'] = 65, ['brush_C_SR'] = 65, ['brush_A_SR'] = 65, ['brush_B_SR'] = 65, ['ARAMChaosTurretInhib'] = 88.4, ['Shen'] = 65, ['Nocturne'] = 65, ['Sona'] = 65, ['ARAMChaosTurretNexus'] = 88.4, ['YellowTrinket'] = 1, ['OrderTurretTutorial'] = 88.4, ['Caitlyn'] = 65, ['Trundle'] = 65, ['Malphite'] = 80.0, ['Mordekaiser'] = 80.0, ['ZyraSeed'] = 65, ['Vi'] = 50, ['Tutorial_Red_Minion_Wizard'] = 48.0, ['Renekton'] = 80.0, ['Anivia'] = 65, ['Fizz'] = 65, ['Heimerdinger'] = 55.0, ['Evelynn'] = 65, ['Rumble'] = 80.0, ['Leblanc'] = 65, ['Darius'] = 80.0, ['OlafAxe'] = 50.0, ['Viktor'] = 65, ['XinZhao'] = 65, ['Orianna'] = 65, ['Vladimir'] = 65, ['Nidalee'] = 65, ['Tutorial_Red_Minion_Basic'] = 48.0, ['ZedShadow'] = 65, ['Syndra'] = 65, ['Zac'] = 80.0, ['Olaf'] = 65, ['Veigar'] = 55.0, ['Twitch'] = 65, ['Alistar'] = 80.0, ['Tristana'] = 65, ['Urgot'] = 80.0, ['Leona'] = 65, ['Talon'] = 65, ['Karma'] = 65, ['Jayce'] = 65, ['Galio'] = 80.0, ['Shaco'] = 65, ['Taric'] = 65, ['TwistedFate'] = 65, ['Varus'] = 65, ['Garen'] = 65, ['Swain'] = 65, ['Vayne'] = 65, ['Fiora'] = 65, ['Quinn'] = 65, ['Kayle'] = 65, ['Blue_Minion_Basic'] = 48.0, ['Brand'] = 65, ['Teemo'] = 55.0, ['Amumu'] = 55.0, ['Annie'] = 55.0, ['Odin_Blue_Minion_caster'] = 48.0, ['Elise'] = 65, ['Nami'] = 65, ['Poppy'] = 55.0, ['AniviaEgg'] = 65, ['Tristana'] = 55.0, ['Graves'] = 65, ['Morgana'] = 65, ['Gragas'] = 80.0, ['MissFortune'] = 65, ['Warwick'] = 65, ['Cassiopeia'] = 65, ['Tutorial_Blue_Minion_Wizard'] = 48.0, ['DrMundo'] = 80.0, ['Volibear'] = 80.0, ['Irelia'] = 65, ['Odin_Red_Minion_Caster'] = 48.0, ['Lucian'] = 65, ['Yorick'] = 80.0, ['RammusPB'] = 65, ['Red_Minion_Basic'] = 48.0, ['Udyr'] = 65, ['MonkeyKing'] = 65, ['Tutorial_Blue_Minion_Basic'] = 48.0, ['Kennen'] = 55.0, ['Nunu'] = 65, ['Ryze'] = 65, ['Zed'] = 65, ['Nautilus'] = 80.0, ['Gangplank'] = 65, ['shopevo'] = 65, ['Lux'] = 65, ['Sejuani'] = 80.0, ['Ezreal'] = 65, ['OdinNeutralGuardian'] = 65, ['Khazix'] = 65, ['Sion'] = 80.0, ['Aatrox'] = 65, ['Hecarim'] = 80.0, ['Pantheon'] = 65, ['Shyvana'] = 50.0, ['Zyra'] = 65, ['Karthus'] = 65, ['Rammus'] = 65, ['Zilean'] = 65, ['Chogath'] = 80.0, ['Malzahar'] = 65, ['YorickRavenousGhoul'] = 1.0, ['YorickSpectralGhoul'] = 1.0, ['JinxMine'] = 65, ['YorickDecayedGhoul'] = 1.0, ['XerathArcaneBarrageLauncher'] = 65, ['Odin_SOG_Order_Crystal'] = 65, ['TestCube'] = 65, ['ShyvanaDragon'] = 80.0, ['FizzBait'] = 65, ['ShopKeeper'] = 65, ['Blue_Minion_MechMelee'] = 65.0, ['OdinQuestBuff'] = 65, ['TT_Buffplat_L'] = 65, ['TT_Buffplat_R'] = 65, ['KogMawDead'] = 65, ['TempMovableChar'] = 48.0, ['Lizard'] = 50.0, ['GolemOdin'] = 80.0, ['OdinOpeningBarrier'] = 65, ['TT_ChaosTurret4'] = 88.4, ['TT_Flytrap_A'] = 65, ['TT_Chains_Order_Periph'] = 65, ['TT_NWolf'] = 65.0, ['ShopMale'] = 65, ['OdinShieldRelic'] = 65, ['TT_Chains_Xaos_Base'] = 65, ['LuluSquill'] = 50.0, ['TT_Shopkeeper'] = 65, ['redDragon'] = 100.0, ['MonkeyKingClone'] = 65, ['Odin_skeleton'] = 65, ['OdinChaosTurretShrine'] = 88.4, ['Cassiopeia_Death'] = 65, ['OdinCenterRelic'] = 48.0, ['Ezreal_cyber_1'] = 65, ['Ezreal_cyber_3'] = 65, ['Ezreal_cyber_2'] = 65, ['OdinRedSuperminion'] = 55.0, ['TT_Speedshrine_Gears'] = 65, ['JarvanIVWall'] = 65, ['DestroyedNexus'] = 65, ['ARAMOrderNexus'] = 65, ['Red_Minion_MechCannon'] = 65.0, ['OdinBlueSuperminion'] = 55.0, ['SyndraOrbs'] = 65, ['LuluKitty'] = 50.0, ['SwainNoBird'] = 65, ['LuluLadybug'] = 50.0, ['CaitlynTrap'] = 65, ['TT_Shroom_A'] = 65, ['ARAMChaosTurretShrine'] = 88.4, ['Odin_Windmill_Propellers'] = 65, ['DestroyedInhibitor'] = 65, ['TT_NWolf2'] = 50.0, ['OdinMinionGraveyardPortal'] = 1.0, ['SwainBeam'] = 65, ['Summoner_Rider_Order'] = 65.0, ['TT_Relic'] = 65, ['odin_lifts_crystal'] = 65, ['OdinOrderTurretShrine'] = 88.4, ['SpellBook1'] = 65, ['Blue_Minion_MechCannon'] = 65.0, ['TT_ChaosInhibitor_D'] = 65, ['Odin_SoG_Chaos'] = 65, ['TrundleWall'] = 65, ['HA_AP_HealthRelic'] = 65, ['OrderTurretShrine'] = 88.4, ['OriannaBall'] = 48.0, ['ChaosTurretShrine'] = 88.4, ['LuluCupcake'] = 50.0, ['HA_AP_ChaosTurretShrine'] = 88.4, ['TT_Chains_Bot_Lane'] = 65, ['TT_NWraith2'] = 50.0, ['TT_Tree_A'] = 65, ['SummonerBeacon'] = 65, ['Odin_Drill'] = 65, ['TT_NGolem'] = 80.0, ['Shop'] = 65, ['AramSpeedShrine'] = 65, ['DestroyedTower'] = 65, ['OriannaNoBall'] = 65, ['Odin_Minecart'] = 65, ['Summoner_Rider_Chaos'] = 65.0, ['OdinSpeedShrine'] = 65, ['TT_Brazier'] = 65, ['TT_SpeedShrine'] = 65, ['odin_lifts_buckets'] = 65, ['OdinRockSaw'] = 65, ['OdinMinionSpawnPortal'] = 1.0, ['SyndraSphere'] = 48.0, ['TT_Nexus_Gears'] = 65, ['Red_Minion_MechMelee'] = 65.0, ['SwainRaven'] = 65, ['crystal_platform'] = 65, ['MaokaiSproutling'] = 48.0, ['Urf'] = 65, ['TestCubeRender10Vision'] = 65, ['MalzaharVoidling'] = 10.0, ['GhostWard'] = 1, ['MonkeyKingFlying'] = 65, ['LuluPig'] = 50.0, ['AniviaIceBlock'] = 65, ['TT_OrderInhibitor_D'] = 65, ['yonkey'] = 65, ['Odin_SoG_Order'] = 65, ['RammusDBC'] = 65, ['FizzShark'] = 65, ['LuluDragon'] = 50.0, ['OdinTestCubeRender'] = 65, ['OdinCrane'] = 65, ['TT_Tree1'] = 65, ['ARAMOrderTurretShrine'] = 88.4, ['TT_Chains_Order_Base'] = 65, ['Odin_Windmill_Gears'] = 65, ['ARAMChaosNexus'] = 65, ['TT_NWraith'] = 50.0, ['TT_OrderTurret4'] = 88.4, ['Odin_SOG_Chaos_Crystal'] = 65, ['TT_SpiderLayer_Web'] = 65, ['OdinQuestIndicator'] = 1.0, ['JarvanIVStandard'] = 65, ['TT_DummyPusher'] = 65, ['OdinClaw'] = 65, ['EliseSpiderling'] = 1.0, ['QuinnValor'] = 65, ['UdyrTigerUlt'] = 65, ['UdyrTurtleUlt'] = 65, ['UdyrUlt'] = 65, ['UdyrPhoenixUlt'] = 65, ['ShacoBox'] = 10, ['HA_AP_Poro'] = 65, ['AnnieTibbers'] = 80.0, ['UdyrPhoenix'] = 65, ['UdyrTurtle'] = 65, ['UdyrTiger'] = 65, ['HA_AP_OrderShrineTurret'] = 88.4, ['HA_AP_OrderTurretRubble'] = 65, ['HA_AP_Chains_Long'] = 65, ['HA_AP_OrderCloth'] = 65, ['HA_AP_PeriphBridge'] = 65, ['HA_AP_BridgeLaneStatue'] = 65, ['HA_AP_ChaosTurretRubble'] = 88.4, ['HA_AP_BannerMidBridge'] = 65, ['HA_AP_PoroSpawner'] = 50.0, ['HA_AP_Cutaway'] = 65, ['HA_AP_Chains'] = 65, ['HA_AP_ShpSouth'] = 65, ['HA_AP_HeroTower'] = 65, ['HA_AP_ShpNorth'] = 65, ['ChaosInhibitor_D'] = 65, ['ZacRebirthBloblet'] = 65, ['OrderInhibitor_D'] = 65, ['Nidalee_Spear'] = 65, ['Nidalee_Cougar'] = 65, ['TT_Buffplat_Chain'] = 65, ['WriggleLantern'] = 1, ['TwistedLizardElder'] = 65.0, ['RabidWolf'] = 65.0, ['HeimerTGreen'] = 50.0, ['HeimerTRed'] = 50.0, ['ViktorFF'] = 65, ['TwistedGolem'] = 80.0, ['TwistedSmallWolf'] = 50.0, ['TwistedGiantWolf'] = 65.0, ['TwistedTinyWraith'] = 50.0, ['TwistedBlueWraith'] = 50.0, ['TwistedYoungLizard'] = 50.0, ['Red_Minion_Melee'] = 48.0, ['Blue_Minion_Melee'] = 48.0, ['Blue_Minion_Healer'] = 48.0, ['Ghast'] = 60.0, ['blueDragon'] = 100.0, ['Red_Minion_MechRange'] = 65.0, ['Test_CubeSphere'] = 65,}
function MyRange(target)
    local myRange = myHero.range + 65
    if ValidTarget(Target) then
        myRange = myRange + hitboxes[Target.charName]
    end
    return myRange
end

function InRange(Target)
    local myRealRange = MyRange(Target)
    if Target and Allclass.GetDistanceSqr(Target) < myRealRange * myRealRange then
        return true
    end
end

function Attack(Target)
    lastAttack = os.clock() + Game.Latency() / 2000
    myHero:Attack(Target)
end

function CanAttack()
	if lastAttack <= os.clock() then
        return os.clock() + Game.Latency() / 2000 > lastAttack + (1 / (myHero.attackSpeed * animationTime))
    end
    return false
end

function CanMove()
    if lastAttack <= os.clock() then
        return os.clock() + Game.Latency() / 2000 > lastAttack + (1 / (myHero.attackSpeed * windUpTime)) + 15 / 1000
    end
    return false
end

function Magnet(Target)
	return Allclass.GetDistanceSqr(mousePos, target) < 150*150 and InRange(target)
end
	
function Orbwalk(Target, point)
    if (Tristana.combokey:IsPressed() or Tristana.harasskey:IsPressed()) and Tristana.Adds.Orbwalk:Value() ==1 then
	    if CanAttack() and ValidTarget(Target) and InRange(Target) then
         Attack(Target)
	    elseif CanMove() and not Magnet(Target) then
	    	if not point then
	            local myVector = Geometry.Vector3(myHero.x, myHero.y, myHero.z)
	            local mouseVector = Geometry.Vector3(mousePos.x, mousePos.y, mousePos.z)
	            local movePoint = myVector + (mouseVector - myVector):Normalize()*200
	            myHero:Move(movePoint.x, movePoint.z)
	        else
	            myHero:Move(point.x, point.z)
	        end
	    end
	end
end


function Autokill()
	for i = 1, Game.HeroCount() do
		hero = Game.Hero(i)

		local heroDistance = Allclass.GetDistanceSqr(hero)
		
		if heroDistance < 640000 and ValidTarget(hero) then

			local qdmg = myHero:CalcMagicDamage(hero, (20*myHero:GetSpellData(0).level+15+.4*myHero.ap))
			local edmg = myHero:CalcMagicDamage(hero, (25*myHero:GetSpellData(2).level+5+0.3*myHero.ap+0.6*myHero.totalDamage))
			local rdmg = myHero:CalcMagicDamage(hero, (75*myHero:GetSpellData(3).level+25+.5*myHero.ap))

			if Qready and hero.health < qdmg and heroDistance < 360000 and Tristana.Ks.useq:Value() then
				myHero:CastSpell(0, hero)
			

			elseif Eready and hero.health < edmg and heroDistance < 105625 and Tristana.Ks.usee:Value() then
				myHero:CastSpell(2, hero)
			

			elseif Rready and heroDistance < 640000 and Tristana.Ks.user:Value() then
				if hero.health < rdmg then
					myHero:CastSpell(3, hero)

				elseif Eready and hero.health < (rdmg+edmg) and Tristana.Ks.usee:Value() then
					myHero:CastSpell(3, hero)

				end
			end
		end
	end
end

function OnDraw()
	-- Thanks to Woody for this cool idea!
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
		if (Tristana.Draw.drawq:Value()) then
			Graphics.DrawCircle(myHero, 600, Farbe)
		end
		if (Tristana.Draw.draww:Value()) then
			Graphics.DrawCircle(myHero, 700, Farbe)
		end
		if (Tristana.Draw.drawe:Value()) then
			Graphics.DrawCircle(myHero, 325, Farbe)
		end
		if (Tristana.Draw.drawr:Value()) then
			Graphics.DrawCircle(myHero, 800, Farbe)
		end
	end
end
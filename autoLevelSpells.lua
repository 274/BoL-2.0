--[[
		Auto Level Spells BY grey (adaptation for 2.0 by greeny)
		v2.0
 
		Levels the abilities of every single Champion
		Written by grey (I REPEAT : grey)
 
		Dont forget to check the abilitySequence of your champion
		Thanks to Zynox and PedobearIGER who gave grey some ideas and tipps.
		Thanks to Jorj for the callback (will make YOU gain FPS, so thx him !!)
]]


Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)

--[[			Globals   ]]
local abilitySequence
local qOff, wOff, eOff, rOff = 0,0,0,0
local levelUse = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, }
local forcemanual = false

function OnStart()
	local champ = player.charName

	if champ == "Aatrox" then		 abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Jinx" then   abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 2, 2, }
	elseif champ == "Ahri" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 2, 2, }
	elseif champ == "Akali" then		abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Alistar" then	abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Amumu" then		abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Anivia" then	  abilitySequence = { 1, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 1, 1, 1, 2, 4, 2, 2, }
	elseif champ == "Annie" then		abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Ashe" then   abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Blitzcrank" then   abilitySequence = { 1, 3, 2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 2, 1, 1, 4, 1, 1, }
	elseif champ == "Brand" then		abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Caitlyn" then	abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Cassiopeia" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Chogath" then	abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Corki" then		abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
	elseif champ == "Darius" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
	elseif champ == "Diana" then		abilitySequence = { 2, 1, 2, 3, 1, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "DrMundo" then	abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Draven" then	  abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Elise" then		abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, } rOff = -1
	elseif champ == "Evelynn" then	abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Ezreal" then	  abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 2, 4, 3, 2, 3, 2, 4, 3, 2, }
	elseif champ == "FiddleSticks" then abilitySequence = { 3, 2, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Fiora" then		abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Fizz" then   abilitySequence = { 3, 1, 2, 1, 2, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Galio" then		abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, }
	elseif champ == "Gangplank" then	abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Garen" then		abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Gragas" then	  abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
	elseif champ == "Graves" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
	elseif champ == "Hecarim" then	abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Heimerdinger" then abilitySequence = { 1, 2, 2, 1, 1, 4, 3, 2, 2, 2, 4, 1, 1, 3, 3, 4, 1, 1, }
	elseif champ == "Irelia" then	  abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 1, 1, 3, 1, 4, 3, 1, }
	elseif champ == "Janna" then		abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, }
	elseif champ == "JarvanIV" then  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 2, 1, 4, 3, 3, 3, 2, 4, 2, 2, }
	elseif champ == "Jax" then	  abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 1, 3, 1, 1, 4, 3, 1, }
	elseif champ == "Jayce" then		abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, } rOff = -1
	elseif champ == "Karma" then		abilitySequence = { 1, 3, 1, 2, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 2, 2, 2, 2, }
	elseif champ == "Karthus" then	abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Kassadin" then  abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Katarina" then  abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
	elseif champ == "Kayle" then		abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
	elseif champ == "Kennen" then	  abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Khazix" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "KogMaw" then	  abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Leblanc" then	abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
	elseif champ == "LeeSin" then	  abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Leona" then		abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Lissandra" then	abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Lucian" then	  abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Lulu" then   abilitySequence = { 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
	elseif champ == "Lux" then	  abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Malphite" then  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
	elseif champ == "Malzahar" then  abilitySequence = { 1, 3, 3, 2, 3, 4, 1, 3, 1, 3, 4, 2, 1, 2, 1, 4, 2, 2, }
	elseif champ == "Maokai" then	  abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
	elseif champ == "MasterYi" then  abilitySequence = { 3, 1, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 2, 2, 4, 2, 2, }
	elseif champ == "MissFortune" then  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "MonkeyKing" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 3, 1, 3, 1, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Mordekaiser" then  abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Morgana" then	abilitySequence = { 1, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Nami" then   abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 2, 3, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Nasus" then		abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
	elseif champ == "Nautilus" then  abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Nidalee" then	abilitySequence = { 2, 3, 1, 3, 1, 4, 3, 2, 3, 1, 4, 3, 1, 1, 2, 4, 2, 2, }
	elseif champ == "Nocturne" then  abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Nunu" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 3, 1, 3, 1, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Olaf" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Orianna" then	abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Pantheon" then  abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
	elseif champ == "Poppy" then		abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, }
	elseif champ == "Quinn" then		abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Rammus" then	  abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
	elseif champ == "Renekton" then  abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Rengar" then	  abilitySequence = { 1, 3, 2, 1, 1, 4, 2, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Riven" then		abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Rumble" then	  abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Ryze" then   abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Sejuani" then	abilitySequence = { 2, 1, 3, 3, 2, 4, 3, 2, 3, 3, 4, 2, 1, 2, 1, 4, 1, 1, }
	elseif champ == "Shaco" then		abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
	elseif champ == "Shen" then   abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Shyvana" then	abilitySequence = { 2, 1, 2, 3, 2, 4, 2, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, }
	elseif champ == "Singed" then	  abilitySequence = { 1, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 2, 3, 2, 4, 2, 3, }
	elseif champ == "Sion" then   abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Sivir" then		abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
	elseif champ == "Skarner" then	abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Sona" then   abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Soraka" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
	elseif champ == "Swain" then		abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Syndra" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Talon" then		abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Taric" then		abilitySequence = { 3, 2, 1, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Teemo" then		abilitySequence = { 1, 3, 2, 3, 3, 4, 1, 3, 1, 3, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Thresh" then	  abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Tristana" then  abilitySequence = { 3, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
	elseif champ == "Trundle" then	abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
	elseif champ == "Tryndamere" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "TwistedFate" then  abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Twitch" then	  abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 1, 2, 2, }
	elseif champ == "Udyr" then   abilitySequence = { 4, 2, 3, 4, 4, 2, 4, 2, 4, 2, 2, 1, 3, 3, 3, 3, 1, 1, }
	elseif champ == "Urgot" then		abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
	elseif champ == "Varus" then		abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Vayne" then		abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Veigar" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, }
	elseif champ == "Vi" then		 abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
	elseif champ == "Viktor" then	  abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, }
	elseif champ == "Vladimir" then  abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Volibear" then  abilitySequence = { 2, 3, 2, 1, 2, 4, 3, 2, 1, 2, 4, 3, 1, 3, 1, 4, 3, 1, }
	elseif champ == "Warwick" then	abilitySequence = { 2, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
	elseif champ == "Xerath" then	  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "XinZhao" then	abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Yorick" then	  abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 1, 4, 2, 1, 2, 1, 4, 2, 1, }
	elseif champ == "Zac" then	  abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Zed" then	  abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Ziggs" then		abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	elseif champ == "Zilean" then	  abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Zyra" then   abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
	else 
		Game.Chat.Print("<font color=\"#F5F5F5\"> >> AutoLevelSpell Script disabled for \"" .. champ .."\".<br> Use manual selection !")
		forcemanual = true
	end

		TheMenu = MenuConfig("AutoLevelSpells")
		TheMenu:Icon("fa-user")

		TheMenu:Section("sequence", "Sequence Settings")
		TheMenu:Menu("manuel", "Manual")
		TheMenu.manuel:Slider("l1", "Level 1", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l2", "Level 2", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l3", "Level 3", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l4", "Level 4", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l5", "Level 5", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l6", "Level 6", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l7", "Level 7", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l8", "Level 8", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l9", "Level 9", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l10", "Level 10", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l11", "Level 11", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l12", "Level 12", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l13", "Level 13", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l14", "Level 14", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l15", "Level 15", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l16", "Level 16", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l17", "Level 17", 0, 0, 4, 1)
		TheMenu.manuel:Slider("l18", "Level 18", 0, 0, 4, 1)
		TheMenu:Menu("auto", "Automatique")
		TheMenu:Section("choose", "Time to choose !!")
		TheMenu:Boolean("m_or_a", "Use Automatique Sequence", false)



	  

		OnLevelUp()

--  Callback.Bind('Tick', function() OnLevelUp() end)
	Callback.Bind('RecvPacket', function(p) OnRecvPacket(p) end)



	Game.Chat.Print("<font color=\"#F5F5F5\">[AutoLevelSpell] by grey (and Greeny) loaded! </font>")


end
 

--[[			Functions	  ]]

-- Thx to Jorj for this callback <3

function OnRecvPacket(p)
	if p.header == 0x3F then
		p.pos = 1
		local sourceNetworkId = p:Decode4()
		local level = p:Decode1()
		local pointsAvailable = p:Decode1()
	
	   Utility.DelayAction(function() OnLevelUp() end, 1000)

	end
end


function OnLevelUp()

	if TheMenu.m_or_a:Value() and forcemanual ~= true then

		local qL = myHero:GetSpellData(0).level + qOff
		local wL = myHero:GetSpellData(1).level + wOff
		local eL = myHero:GetSpellData(2).level + eOff
		local rL = player:GetSpellData(3).level + rOff
		
		if qL + wL + eL + rL < myHero.level then
			local level = { 0, 0, 0, 0 }
			for i = 1, player.level, 1 do
				level[abilitySequence[i]] = level[abilitySequence[i]] + 1
			end
			for i, v in ipairs({ qL, wL, eL, rL }) do
				if v < level[i] then Game.LevelSpell(i - 1) end
			end
		end

	else
		
		local qL = myHero:GetSpellData(0).level + qOff
		local wL = myHero:GetSpellData(1).level + wOff
		local eL = myHero:GetSpellData(2).level + eOff
		local rL = player:GetSpellData(3).level + rOff

		if qL + wL + eL + rL < myHero.level then

			if levelUse[1] == 0 then
				if TheMenu.manuel.l1:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l1:Value() - 1)
					levelUse[1] = 42
			end end

			if levelUse[2] == 0 then
				if TheMenu.manuel.l2:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l2:Value() - 1)
					levelUse[2] = 42
			end end

			if levelUse[3] == 0 then
				if TheMenu.manuel.l3:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l3:Value() - 1)
					levelUse[3] = 42
			end end

			if levelUse[4] == 0 then
				if TheMenu.manuel.l4:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l4:Value() - 1)
					levelUse[4] = 42
			end end

			if levelUse[5] == 0 then
				if TheMenu.manuel.l5:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l5:Value() - 1)
					levelUse[5] = 42
			end end

			if levelUse[6] == 0 then
				if TheMenu.manuel.l6:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l6:Value() - 1)
					levelUse[6] = 42
			end end

			if levelUse[7] == 0 then
				if TheMenu.manuel.l7:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l7:Value() - 1)
					levelUse[7] = 42
			end end

			if levelUse[8] == 0 then
				if TheMenu.manuel.l8:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l8:Value() - 1)
					levelUse[8] = 42
			end end

			if levelUse[9] == 0 then
				if TheMenu.manuel.l9:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l9:Value() - 1)
					levelUse[9] = 42
			end end

			if levelUse[10] == 0 then
				if TheMenu.manuel.l10:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l10:Value() - 1)
					levelUse[10] = 42
			end end

			if levelUse[11] == 0 then
				if TheMenu.manuel.l11:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l11:Value() - 1)
					levelUse[11] = 42
			end end

			if levelUse[12] == 0 then
				if TheMenu.manuel.l12:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l12:Value() - 1)
					levelUse[12] = 42
			end end

			if levelUse[13] == 0 then
				if TheMenu.manuel.l13:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l13:Value() - 1)
					levelUse[13] = 42
			end end

			if levelUse[14] == 0 then
				if TheMenu.manuel.l14:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l14:Value() - 1)
					levelUse[14] = 42
			end end

			if levelUse[15] == 0 then
				if TheMenu.manuel.l15:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l15:Value() - 1)
					levelUse[15] = 42
			end end

			if levelUse[16] == 0 then
				if TheMenu.manuel.l16:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l16:Value() - 1)
					levelUse[16] = 42
			end end

			if levelUse[17] == 0 then
				if TheMenu.manuel.l17:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l17:Value() - 1)
					levelUse[17] = 42
			end end

			if levelUse[18] == 0 then
				if TheMenu.manuel.l18:Value() ~= 0 then
					Game.LevelSpell(TheMenu.manuel.l18:Value() - 1)
					levelUse[18] = 42
				end
			end
		end
	end
end
 
--[[
 ----------------------------------------------------------------------------
 "THE BEER-WARE LICENSE" (Revision 42):
 Green Death and fROMAGE wrote this file. As long as you retain this 
 notice you can do whatever you want with this stuff (exept sell it).
 If we meet some day, and you think this stuff
 is worth it, you can buy us a beer in return 
 ----------------------------------------------------------------------------
]]


-- Version : 1.0.0.42



Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)
  Callback.Bind('RecvChat', function(from, msg) OnChatMessage(from, msg) end)
end)

local memory 	= {0, 0, 0, 0}
local stack		= {}
local mi		= 1  -- memory iterator
local sc		= 0  -- stack counter
local pi		= 1  -- program iterator
local buffer	= "" -- input buffer
local _r		= false -- request read
local prog		= "" -- program
local Watchdog	= 0

function OnStart()
	menu = MenuConfig("Brainfuck")

	menu:Icon('fa-stack-overflow')
	menu:Section('Brainfuck', 'Brainfuck')
	menu:Boolean('Enable', 'Enable', true)
	menu:Boolean('Local', 'Output to local chat', true)
	menu:Slider('Watchdog', 'Infinite loop protection', 1000, 100, 4242, 42)
end

function OnChatMessage(from, msg)
	if menu.Enable:Value() then
		Game.Chat.Block()
		if menu.Local:Value() then
			Game.Chat.Print(msg)
		else
			Game.Chat.Send(msg)
		end
		if _r then
			buffer = msg
			_r = false
			Run()
		else
			print(msg)
			prog = msg
			Run()
		end

	end
end

function Run()
	while pi <= #prog do
		local c = prog:sub(pi, pi)

		if watchdog >= menu.Watchdog:Value() then
			reinit()
			return
		end 

		if c == '.' then
			if menu.Local:Value() then
				Game.Chat.Print(string.char(memory[mi]))
			else
				Game.Chat.Send(string.char(memory[mi]))
			end
		elseif c == ',' then
			if #buffer > 0 then
				memory[mi] = string.byte(buffer)
				string.sub(buffer, 1)
			else
				_r = true
				return
			end
		elseif c == '>' then
			mi = mi + 1
			if (memory[mi] == nil) then
				memory[mi] = 0
			end
		elseif c == '<' then
			mi = mi - 1
		elseif c == '+' then
			memory[mi] = memory[mi] + 1
		elseif c == '-' then
			memory[mi] = memory[mi] - 1
		elseif c == '[' then
			if memory[mi] == 0 then
				pi = SkipBlock(c) - 1
				if pi <= -42 then
					return -- Error
				end
			else
				sc = sc + 1
				stack[sc] = pi
			end
		elseif c == ']' then
			if sc <= 0 then
				return -- Error
			end
			pi = stack[sc] - 1
			sc = sc - 1
		end
		pi = pi + 1
		watchdog = watchdog + 1
	end
	reinit()
end

function SkipBlock(i)
	local tmp = 0

	while i < #prog do
		local c = prog:sub(i, i)
		if c == ']' then
			tmp = tmp - 1
		elseif c == '[' then
			tmp = tmp + 1
		end
		i = i + 1
		if tmp == 0 then
			return i
		end
	end
	return -42
end

function reinit() -- set all var to default
	memory 	= {0, 0, 0, 0}
	stack	= {}
	mi		= 1
	sc		= 0
	pi		= 1
	buffer	= ""
	_r		= false
	prog	= ""
	Watchdog	= 0
end

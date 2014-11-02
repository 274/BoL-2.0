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
local bi		= -1  -- buffer iterator

function OnStart()
	menu = MenuConfig("Brainfuck")

	menu:Section('Brainfuck', 'Brainfuck')
	menu:Boolean('Enable', 'Enable', true)
	menu:Boolean('Local', 'Output to local chat', true)
end

function OnChatMessage(from, msg)
	if menu.Enable:Value() then
		print(msg)
		Run(msg)
		if menu.Local:Value() then
			Game.Chat.Block()
		end
	end
end

function Run(prog)
	while pi <= #prog do
		local c = prog:sub(pi, pi)

		if c == '.' then
			Game.Chat.Send(string.char(memory[mi]))
		elseif c == ',' then
			memory[mi] = io.read(1)
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
	end
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

function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

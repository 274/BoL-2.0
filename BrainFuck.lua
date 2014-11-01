Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)
  Callback.Bind('RecvChat', function(from, msg) OnChatMessage(from, msg) end)
end)

function OnStart()
	menu = MenuConfig("Brainfuck")

	menu:Section('Brainfuck', 'Brainfuck')
	menu:Boolean('Enable', 'Enable', true)
	menu:Boolean('Local', 'Output to local chat', true)
end

function OnChatMessage(from, msg)
	if (menu.Enable:Value() or string.starts(msg, "/bf")) then
		print(msg)
		Run(msg)
		if (menu.Local:Value()) then
			Game.Chat.Block()
		end
	end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
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

function Run(prog)
	local i = 1

	while i <= #prog do
		local c = prog:sub(i, i)

		if c == '.' then
			Game.Chat.Send(string.char(memory[pc]))
		elseif c == ',' then
			memory[pc] = io.read(1)
		elseif c == '>' then
			pc = pc + 1
			if (memory[pc] == nil) then
				memory[pc] = 0
			end
		elseif c == '<' then
			pc = pc - 1
		elseif c == '+' then
			memory[pc] = memory[pc] + 1
		elseif c == '-' then
			memory[pc] = memory[pc] - 1
		elseif c == '[' then
			if memory[pc] == 0 then
				i = SkipBlock(i) - 1
				if i == -42 then
					return "PATATE" -- Error
				end
			else
				sc = sc + 1
				stack[sc] = i
			end
		elseif c == ']' then
			if sc <= 0 then
				return -- Error
			end
			i = stack[sc] - 1
			sc = sc - 1
		end
		i = i + 1
	end
end

memory 	= {0, 0, 0, 0}
stack	= {}
pc		= 1 -- program counter
sc		= 0 -- stack counter

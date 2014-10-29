memory 	= {0, 0, 0, 0}
stack	= {}
pc		= 1 -- program counter
sc		= 0 -- stack counter

--prog = "[[]"

prog = ">++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>>+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++." --temp

--prog = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."

--prog = "+[>+[>+]>]<.<.<."

fackulua = 418

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

function Run()
	local i = 1

	while i <= #prog do
		local c = prog:sub(i, i)

		if c == '.' then
			io.write(string.char(memory[pc]))
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

if fackulua == 418 then
	fackulua = 404
	Run()
end

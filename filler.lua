local random = love.math.random

local tokens = {
	V = { "a", "e", "i", "o", "u" },
	C = { "p", "t", "k", "f", "s", "b", "d", "g", "v", "z", "n" },
	C2 = { "p", "t", "k", "b", "d", "g" },
	N = { "s", "n" },
	S = { "y", "s", "h" },
	--
	B = { "V", "M" },
	M = { "C V:3", "C V N:2", "M2" },
	M2 = { "C2 S V", "C2 S V N" },
	E = { "M", "M C" },
	--
	W = { "E", "B M:2", "B M E:2", "V C" },
}

local replace = {
	{ "nn", "n" },
	{ "ss", "sh" },
	{ "sz", "z" },
}

for _, t in pairs(tokens) do
	for i = #t, 1, -1 do
		local token, freq = t[i]:match("(.+):(.+)")

		if freq then
			table.remove(t, i)
			for _ = 1, tonumber(freq) do
				table.insert(t, token)
			end
		end
	end
end

local function split(s)
	local result = {}

	for match in s:gmatch("[^%s]+") do
		table.insert(result, match)
	end

	return result
end

local function word_gen()
	local num = random(#tokens.W)
	local word = split(tokens.W[num])

	local replaced = true

	while replaced do
		replaced = false

		for i, v in ipairs(word) do
			if tokens[v] then
				replaced = true
				table.remove(word, i)

				local t = split(tokens[v][random(#tokens[v])])

				for j = #t, 1, -1 do
					table.insert(word, i, t[j])
				end

				break
			end
		end
	end

	local result = table.concat(word)

	for _, rule in ipairs(replace) do
		result = result:gsub(unpack(rule))
	end

	return result
end

local function sentence_gen(min, max)
	min = min or 3
	max = max or 20

	local count = random(min, max)
	local sentence = {}

	for i = 1, count do
		if random() < 0.1 and i < count then
			table.insert(sentence, word_gen() .. ",")
		else
			table.insert(sentence, word_gen())
		end
	end

	sentence[1] = sentence[1]:sub(1, 1):upper() .. sentence[1]:sub(2)

	return table.concat(sentence, " ") .. "."
end

local text = {}
for _ = 1, 10 do
	table.insert(text, sentence_gen())
end

local result = table.concat(text, " ")

love.system.setClipboardText(result)
print(result)

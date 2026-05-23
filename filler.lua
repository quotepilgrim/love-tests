local random = love.math.random
local conf = require("filler.default")

local tokens = conf.tokens
local replace = conf.replace

local weights = {}
local use_lexicon = false
local count

while #arg > 0 do
	local a = table.remove(arg, 1)
	if a == "-l" then
		if tonumber(arg[1]) then
			count = tonumber(table.remove(arg, 1))
		end

		use_lexicon = true
	end
end

for k, t in pairs(tokens) do
	weights[k] = {}

	local cum_weight = 0
	for i, v in ipairs(t) do
		local match, weight = v:match("(.+):(.+)")
		cum_weight = cum_weight + (tonumber(weight) or 1)

		weights[k][i] = cum_weight

		if match then
			t[i] = match
		end
	end
end

local function split(s)
	local result = {}

	for match in s:gmatch("[^+]+") do
		table.insert(result, match)
	end

	return result
end

local function get_random(s)
	local max_weight = weights[s][#weights[s]]

	local val = love.math.random() * max_weight
	local weight = 0

	for i = 1, #weights[s] do
		weight = weights[s][i]
		if weight >= val then
			return tokens[s][i]
		end
	end
end

local function generate_word(lexicon)
	if lexicon then
		local num = math.min(random(#lexicon), random(#lexicon))
		return lexicon[num]
	end

	local num = random(#tokens.W)
	local word = split(tokens.W[num])

	local replaced = true

	while replaced do
		replaced = false

		for i, v in ipairs(word) do
			if tokens[v] then
				replaced = true
				table.remove(word, i)

				local t = split(get_random(v))

				for j = #t, 1, -1 do
					table.insert(word, i, t[j])
				end

				break
			end
		end
	end

	local result = table.concat(word)

	if replace then
		for _ = 1, 1000 do
			local old = result

			for _, rule in ipairs(replace) do
				result = result:gsub(unpack(rule))
			end

			if result == old then
				break
			end
		end
	end

	return result
end

local function sentence_gen(min, max, lexicon)
	min = min or 3
	max = max or 20

	local length = random(min, max)
	local sentence = {}

	for i = 1, length do
		if random() < 0.1 and i < length then
			table.insert(sentence, generate_word(lexicon) .. ",")
		else
			table.insert(sentence, generate_word(lexicon))
		end
	end

	sentence[1] = sentence[1]:sub(1, 1):upper() .. sentence[1]:sub(2)

	return table.concat(sentence, " ") .. "."
end

local lexicon

if use_lexicon then
	lexicon = {}
	for _ = 1, (count or 200) do
		table.insert(lexicon, generate_word())
	end
end

local text = {}
for _ = 1, 20 do
	table.insert(text, sentence_gen(nil, nil, lexicon))
end

local result = table.concat(text, " ")

love.system.setClipboardText(result)
print(result)

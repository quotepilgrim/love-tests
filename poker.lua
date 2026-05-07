local shuffle = require("shuffle")
local combinations = require("combinations")

local cards = {}

for _, s in ipairs({ "S", "H", "C", "D" }) do
	for r = 2, 14 do
		table.insert(cards, { r, s })
	end
end

local hand_types = {
	highcard = 0,
	pair = 1,
	twopair = 2,
	threeofakind = 3,
	straight = 4,
	flush = 5,
	fullhouse = 6,
	fourofakind = 7,
	straightflush = 8,
}

local function hand_str(hand)
	local result = {}

	for _, t in ipairs(hand) do
		local r, s = unpack(t)
		table.insert(result, string.format("%2s", r) .. "-" .. s)
	end

	return table.concat(result, " ")
end

local function get_type(hand)
	local straight, flush = true, true
	local counts = {}
	local pair_count = 0
	local tri = false
	local quad = false

	for _, v in ipairs(hand) do
		counts[v[1]] = counts[v[1]] and counts[v[1]] + 1 or 1
	end

	table.sort(hand, function(a, b)
		if counts[a[1]] == counts[b[1]] then
			return a[1] == b[1] and a[2] > b[2] or a[1] > b[1]
		else
			return counts[a[1]] > counts[b[1]]
		end
	end)

	for i = 4, 1, -1 do
		if hand[i][1] - hand[i + 1][1] ~= 1 then
			if i == 1 and straight and hand[2][1] == 5 and hand[1][1] == 14 then
				local ace = table.remove(hand, 1)
				table.insert(hand, ace)
			else
				straight = false
			end
		end

		if hand[i][2] ~= hand[i + 1][2] then
			flush = false
		end
	end

	for _, v in pairs(counts) do
		if v == 2 then
			pair_count = pair_count + 1
		elseif v == 3 then
			tri = true
		elseif v == 4 then
			quad = true
		end
	end

	if flush then
		if straight then
			return hand_types.straightflush
		else
			return hand_types.flush
		end
	end

	if straight then
		return hand_types.straight
	end

	if quad then
		return hand_types.fourofakind
	end

	if tri then
		if pair_count > 0 then
			return hand_types.fullhouse
		else
			return hand_types.threeofakind
		end
	end

	if pair_count == 2 then
		return hand_types.twopair
	end

	if pair_count == 1 then
		return hand_types.pair
	end

	return hand_types.highcard
end

local function is_better(a, b)
	local a_type = get_type(a)
	local b_type = get_type(b)

	if a_type ~= b_type then
		return a_type > b_type
	end

	for i = 1, 5 do
		if a[i][1] > b[i][1] then
			return true
		elseif b[i][1] > a[i][1] then
			return false
		end
	end

	return false
end

local combs = combinations(7, 5)

local function find_best(hand)
	assert(#hand == 7)
	local curr = {}

	for i = 1, 5 do
		curr[i] = hand[i]
	end

	for _, comb in ipairs(combs) do
		local new = {}
		for i, v in ipairs(comb) do
			new[i] = hand[v]
		end

		if is_better(new, curr) then
			curr = new
		end
	end

	return curr
end

local hands = { {}, {} }
local best = { {}, {} }

local total = 0
local losses = 0

local start = love.timer.getTime()
for _ = 1, 1000000 do
	shuffle(cards)

	for i = 1, 7 do
		hands[1][i] = cards[i]
	end

	for i = 3, 9 do
		hands[2][i - 2] = cards[i]
	end

	best[1] = find_best(hands[1])
	best[2] = find_best(hands[2])

	if get_type(best[1]) == hand_types.twopair then
		total = total + 1
		if is_better(best[2], best[1]) then
			losses = losses + 1
		end
	end
end

print(total, losses, losses / total)
print(love.timer.getTime() - start)

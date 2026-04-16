local shuffle = require("shuffle")

local cards = {
	{ 2, "S" },
	{ 3, "S" },
	{ 4, "S" },
	{ 5, "S" },
	{ 6, "S" },
	{ 7, "S" },
	{ 8, "S" },
	{ 9, "S" },
	{ 10, "S" },
	{ 11, "S" },
	{ 12, "S" },
	{ 13, "S" },
	{ 14, "S" },
	{ 2, "H" },
	{ 3, "H" },
	{ 4, "H" },
	{ 5, "H" },
	{ 6, "H" },
	{ 7, "H" },
	{ 8, "H" },
	{ 9, "H" },
	{ 10, "H" },
	{ 11, "H" },
	{ 12, "H" },
	{ 13, "H" },
	{ 14, "H" },
	{ 2, "C" },
	{ 3, "C" },
	{ 4, "C" },
	{ 5, "C" },
	{ 6, "C" },
	{ 7, "C" },
	{ 8, "C" },
	{ 9, "C" },
	{ 10, "C" },
	{ 11, "C" },
	{ 12, "C" },
	{ 13, "C" },
	{ 14, "C" },
	{ 2, "D" },
	{ 3, "D" },
	{ 4, "D" },
	{ 5, "D" },
	{ 6, "D" },
	{ 7, "D" },
	{ 8, "D" },
	{ 9, "D" },
	{ 10, "D" },
	{ 11, "D" },
	{ 12, "D" },
	{ 13, "D" },
	{ 14, "D" },
}

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

local function comp(a, b)
	return a[1] == b[1] and a[2] < b[2] or a[1] < b[1]
end

local function get_type(hand)
	local straight, flush = true, true
	local counts = {}
	local pair_count = 0
	local tri = false
	local quad = false

	table.sort(hand, comp)

	for i = 2, 5 do
		if i == 5 and straight and hand[1][1] == 2 and hand[i][1] == 14 then
		--  pass
		elseif hand[i][1] - hand[i - 1][1] ~= 1 then
			straight = false
		end

		if hand[i][2] ~= hand[i - 1][2] then
			flush = false
		end
	end

	for _, v in ipairs(hand) do
		counts[v[1]] = counts[v[1]] and counts[v[1]] + 1 or 1
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

	if a_type > b_type then
		return true
	elseif b_type > a_type then
		return false
	end

	if a_type == hand_types.highcard or a_type == hand_types.straight or a_type == hand_types.straightflush then
		return a[5][1] > b[5][1]
	elseif a_type == hand_types.pair or a_type == hand_types.threeofakind or a_type == hand_types.fourofakind then
		local a_card, b_card
		for i = 2, 5 do
			if a[i][1] == a[i - 1][1] then
				a_card = a[i][1]
			end
			if b[i][1] == b[i - 1][1] then
				b_card = b[i][1]
			end
		end
		return a_card > b_card
	elseif a_type == hand_types.twopair then
		local a_pairs = {}
		local b_pairs = {}
		for i = 2, 5 do
			if a[i][1] == a[i - 1][1] then
				table.insert(a_pairs, b[i][1])
			end
			if b[i][1] == b[i - 1][1] then
				table.insert(b_pairs, b[i][1])
			end
		end
		return a_pairs[2] == b_pairs[2] and a_pairs[1] > b_pairs[1] or a_pairs[2] > b_pairs[2]
	elseif a_type == hand_types.flush then
		for i = 5, 1, -1 do
			if a[i][1] > b[i][1] then
				return true
			end
		end
	elseif a_type == hand_types.fullhouse then
		local a2, a3, b2, b3

		if a[2][1] == a[3][1] then
			a2 = a[5][1]
			a3 = a[1][1]
		else
			a2 = a[1][1]
			a3 = a[5][1]
		end

		if b[2][1] == b[3][1] then
			b2 = b[5][1]
			b3 = b[1][1]
		else
			b2 = b[1][1]
			b3 = b[5][1]
		end

		return a3 == b3 and a2 > b2 or a3 > b3
	end

	return false
end

local combs = {
	{ 1, 2, 3, 4, 5 },
	{ 1, 2, 3, 4, 6 },
	{ 1, 2, 3, 4, 7 },
	{ 1, 2, 3, 5, 6 },
	{ 1, 2, 3, 5, 7 },
	{ 1, 2, 3, 6, 7 },
	{ 1, 2, 4, 5, 6 },
	{ 1, 2, 4, 5, 7 },
	{ 1, 2, 4, 6, 7 },
	{ 1, 2, 5, 6, 7 },
	{ 1, 3, 4, 5, 6 },
	{ 1, 3, 4, 5, 7 },
	{ 1, 3, 4, 6, 7 },
	{ 1, 3, 5, 6, 7 },
	{ 1, 4, 5, 6, 7 },
	{ 2, 3, 4, 5, 6 },
	{ 2, 3, 4, 5, 7 },
	{ 2, 3, 4, 6, 7 },
	{ 2, 3, 5, 6, 7 },
	{ 2, 4, 5, 6, 7 },
	{ 3, 4, 5, 6, 7 },
}

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

	table.sort(hands[1], comp)
	table.sort(hands[2], comp)
end

print(total, losses, losses / total)
print(love.timer.getTime() - start)

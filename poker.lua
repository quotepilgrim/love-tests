local shuffle = require("shuffle")

local cards = {
	"2-S",
	"3-S",
	"4-S",
	"5-S",
	"6-S",
	"7-S",
	"8-S",
	"9-S",
	"10-S",
	"11-S",
	"12-S",
	"13-S",
	"14-S",
	"2-H",
	"3-H",
	"4-H",
	"5-H",
	"6-H",
	"7-H",
	"8-H",
	"9-H",
	"10-H",
	"11-H",
	"12-H",
	"13-H",
	"14-H",
	"2-C",
	"3-C",
	"4-C",
	"5-C",
	"6-C",
	"7-C",
	"8-C",
	"9-C",
	"10-C",
	"11-C",
	"12-C",
	"13-C",
	"14-C",
	"2-D",
	"3-D",
	"4-D",
	"5-D",
	"6-D",
	"7-D",
	"8-D",
	"9-D",
	"10-D",
	"11-D",
	"12-D",
	"13-D",
	"14-D",
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
	local a_rank, a_suit = a:match("(%d+)-(.)")
	local b_rank, b_suit = b:match("(%d+)-(.)")

	return a_rank == b_rank and a_suit < b_suit or tonumber(a_rank) < tonumber(b_rank)
end

local function get_type(hand)
	local straight, flush = true, true
	local ranks, suits = {}, {}
	local counts = {}
	local pair_count = 0
	local triple = false
	local quad = false

	table.sort(hand, comp)

	for i = 1, 5 do
		local card = hand[i]
		local r, s = card:match("([^-]+)-(.+)")
		table.insert(ranks, r)
		table.insert(suits, s)
	end

	table.sort(ranks)

	for i = 2, 5 do
		if ranks[i] - ranks[i - 1] ~= 1 then
			straight = false
		end
		if suits[i] ~= suits[i - 1] then
			flush = false
		end
	end

	for _, v in ipairs(ranks) do
		counts[v] = counts[v] and counts[v] + 1 or 1
	end

	for _, v in pairs(counts) do
		if v == 2 then
			pair_count = pair_count + 1
		elseif v == 3 then
			triple = true
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

	if triple then
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

	local a_indices = {}
	local b_indices = {}

	for i = 1, 5 do
		table.insert(a_indices, tonumber(a[i]:match("%d+")))
		table.insert(b_indices, tonumber(b[i]:match("%d+")))
	end

	if a_type == hand_types.highcard or a_type == hand_types.straight or a_type == hand_types.straightflush then
		return a_indices[5] > b_indices[5]
	elseif a_type == hand_types.pair or a_type == hand_types.threeofakind or a_type == hand_types.fourofakind then
		local a_card, b_card
		for i = 2, 5 do
			if a_indices[i] == a_indices[i - 1] then
				a_card = a_indices[i]
			end
			if b_indices[i] == b_indices[i - 1] then
				b_card = b_indices[i]
			end
		end
		return a_card > b_card
	elseif a_type == hand_types.twopair then
		local a_pairs = {}
		local b_pairs = {}
		for i = 2, 5 do
			if a_indices[i] == a_indices[i - 1] then
				table.insert(a_pairs, a_indices[i])
			end
			if b_indices[i] == b_indices[i - 1] then
				table.insert(b_pairs, b_indices[i])
			end
		end
		return a_pairs[2] == b_pairs[2] and a_pairs[1] > b_pairs[1] or a_pairs[2] > b_pairs[2]
	elseif a_type == hand_types.flush then
		for i = 5, 1, -1 do
			if a_indices[i] > b_indices[i] then
				return true
			end
		end
	elseif a_type == hand_types.fullhouse then
		local a2, a3, b2, b3

		if a_indices[2] == a_indices[3] then
			a2 = a_indices[5]
			a3 = a_indices[1]
		else
			a2 = a_indices[1]
			a3 = a_indices[5]
		end

		if b_indices[2] == b_indices[3] then
			b2 = b_indices[5]
			b3 = b_indices[1]
		else
			b2 = b_indices[1]
			b3 = b_indices[5]
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

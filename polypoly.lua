-- Polypolybius cipher
local M = {}

local min = math.min
local random = love.math.random

local alphabet = {
	{ "a", "b", "c", "d", "e" },
	{ "f", "g", "h", "i", "k" },
	{ "l", "m", "n", "o", "p" },
	{ "q", "r", "s", "t", "u" },
	{ "v", "w", "x", "y", "z" },
}

local function find(c)
	c = c:lower():gsub("j", "i")
	for i, row in ipairs(alphabet) do
		for j, col in ipairs(row) do
			if c == col then
				return i, j
			end
		end
	end

	return nil
end

function M.encode(s)
	local coords = {}
	local result = {}
	local upper = {}

	for i = 1, #s do
		local c = s:sub(i, i)
		local y, x = find(c)
		if x then
			table.insert(coords, { y, x })
		else
			table.insert(coords, { c })
		end
		table.insert(upper, c == c:upper())
	end

	for i, t in ipairs(coords) do
		if #t == 2 then
			for j, c in ipairs(t) do
				local num = min(random(1, 5), random(1, 5))
				t[j] = alphabet[num][c]
			end
		end

		table.insert(result, upper[i] and table.concat(t):upper() or table.concat(t))
	end

	return table.concat(result)
end

function M.decode(s, nums)
	local coords = {}
	local result = {}

	for i = 1, #s do
		local c = s:sub(i, i)
		local _, n = find(c)

		if n and nums then
			table.insert(result, n)
		elseif n then
			table.insert(coords, n)

			if #coords == 2 then
				local x = table.remove(coords)
				local y = table.remove(coords)
				table.insert(result, c:upper() == c and alphabet[y][x]:upper() or alphabet[y][x])
			end
		else
			table.insert(result, c)
		end
	end

	return table.concat(result)
end

return M

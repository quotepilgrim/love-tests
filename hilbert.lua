local function index2coords(index, order)
	index = index - 1
	local width = 2 ^ order

	local positions = {
		{ 0, 0 },
		{ 0, 1 },
		{ 1, 1 },
		{ 1, 0 },
	}

	local pos = bit.band(index, 3)
	index = bit.rshift(index, 2)

	local x, y = unpack(positions[pos + 1])

	local n = 4
	while n <= width do
		local n2 = n / 2

		pos = bit.band(index, 3)
		if pos == 0 then
			x, y = y, x
		elseif pos == 1 then
			y = y + n2
		elseif pos == 2 then
			x = x + n2
			y = y + n2
		else
			x, y = (n2 - 1) - y + n2, (n2 - 1) - x
		end

		index = bit.rshift(index, 2)

		n = n * 2
	end

	return x, y
end

local M = {}
local polygon = {}
local nums = {}

local ww = 1000
local order = 8
local n = 2 ^ order
local count = n ^ 2
local w = ww / n
local draw_lines = false

function M.load()
	love.window.setMode(ww, ww)
	for i = 1, n ^ 2 do
		local x, y = index2coords(i, order)
		table.insert(polygon, x * w)
		table.insert(polygon, y * w)

		x, y = x + 1, y + 1
		nums[x] = nums[x] or {}
		nums[x][y] = i
	end
end

function M.draw()
	for x, t in ipairs(nums) do
		for y, v in ipairs(t) do
			love.graphics.setColor(v / count, 1 - v / count, 0.75)
			love.graphics.rectangle("fill", (x - 1) * w, (y - 1) * w, w, w)
		end
	end

	if draw_lines then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.translate(0.5 * w, 0.5 * w)

		love.graphics.line(polygon)
	end
end

function M.keypressed(key)
	if key == "space" then
		draw_lines = not draw_lines
	end
end

return M

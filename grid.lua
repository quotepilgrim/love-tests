local M = {}

local grid = {}
local font
local sw = 5
local cw = 48
local hw = math.floor(cw / 2)
local A = ("A"):byte()
local Z = ("Z"):byte()

local word = "SUBSTANCE"

local function random_row()
	local row = {}
	for _ = 1, sw ^ 2 do
		table.insert(row, string.char(love.math.random(A, Z)))
	end

	return row
end

local function get_frequency(t)
	local counts = {}
	local counts_t = {}

	for _, v in ipairs(t) do
		if not counts[v] then
			counts[v] = 1
		else
			counts[v] = counts[v] + 1
		end
	end

	for k, v in pairs(counts) do
		table.insert(counts_t, { k, v })
	end

	table.sort(counts_t, function(a, b)
		return b[2] < a[2]
	end)

	return counts_t
end

function M.load()
	love.window.setMode(cw * sw * 3, cw * sw * 3)
	font = love.graphics.newFont("assets/sundaycomicsbb.ttf", cw)
	love.graphics.setFont(font)
	for _ = 1, 9 do
		table.insert(grid, random_row())
	end

	for i = 1, 9 do
		local f = get_frequency(grid[i])
		local mf = f[1][1]
		local n1 = f[1][2]
		local n2 = f[2] and f[2][2]
		local lf = f[#f][1]
		local c = word:sub(i, i)

		for j, v in ipairs(grid[i]) do
			if v == mf or (v == lf and n1 == n2) then
				grid[i][j] = c
			end
		end

		f = get_frequency(grid[i])
		assert(f[1][1] == c)
	end
end

function M.draw()
	love.graphics.clear(1, 1, 1, 1)
	love.graphics.setColor(0, 0, 0, 1)
	local x, y = 0, 0

	for i = 1, 9 do
		for j = 1, #grid[i] do
			love.graphics.print(grid[i][j], x + hw - math.floor(font:getWidth(grid[i][j]) / 2), y)

			if j % sw == 0 then
				y = y + cw
				x = x - cw * sw
			end
			x = x + cw
		end
		y = y - sw * cw
		x = x + sw * cw
		if i % 3 == 0 then
			y = y + sw * cw
			x = x - sw * cw * 3
		end
	end
end

function M.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "s" then
		love.graphics.captureScreenshot(function(image)
			image:encode("png", table.concat(grid[1]):sub(1, 5):lower() .. ".png")
			love.event.quit()
		end)
	end
end

return M

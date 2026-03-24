local M = {}
local TWO_PI = math.pi * 2
local G = 10
local W = 40

local dist = 200
local ox, oy = 400, 400
local me = { x = 0, y = 0 }

local function distance(p1, p2)
	return math.sqrt((p2.y - p1.y) ^ 2 + (p2.x - p1.x) ^ 2)
end

local function generate_points(count)
	local points = {}
	for i = 1, count do
		i = i * TWO_PI / count
		table.insert(points, { x = math.cos(i) * dist, y = math.sin(i) * dist })
	end
	return points
end

local function shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

local count = 64
local mass = W / count
local points = generate_points(count)

love.window.setMode(800, 800)

M.update = function()
	shuffle(points)
	for _, p in ipairs(points) do
		local d = distance(me, p)
		if d < 2 then
			break
		end
		local g = (G * mass / d ^ 2)
		local dir = math.atan2(p.y - me.y, p.x - me.x)
		me.x = me.x + g * math.cos(dir) * d
		me.y = me.y + g * math.sin(dir) * d
	end
end

M.draw = function()
	love.graphics.print("points: " .. count)
	love.graphics.translate(ox, oy)
	for _, p in ipairs(points) do
		love.graphics.circle("fill", p.x, p.y, 2)
	end
	love.graphics.setColor(0.5, 1, 0, 1)
	love.graphics.circle("fill", me.x, me.y, 2)
	love.graphics.setColor(1, 1, 1, 1)
end

M.mousepressed = function(x, y)
	me.x = x - ox
	me.y = y - oy
end

M.keypressed = function(key)
	if key == "=" then
		count = math.min(1024, count * 2)
	elseif key == "-" then
		count = math.max(2, count / 2)
	end
	points = generate_points(count)
	mass = W / count
end

for i = 0, 100 do
	for j = i, 100 do
		for k = j, 100 do
			local a = i
			local b = j - i
			local c = k - j
			local d = 100 - k
			assert(a + b + c + d == 100)
		end
	end
end

return M

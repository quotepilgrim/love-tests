local M = {}

local points = {}
local points_by_distance = {}
local draw_points = true

local ww, wh = 1000, 1000
local sw, sh = 960, 960
local ox, oy = (ww - sw) / 2, (wh - sh) / 2
local x_count, y_count = 23, 23

local speeds = { 1, 2, 3, 5, 7, 10, 15, 20, 30, 60 }
local s_index = 2
local speed = speeds[s_index]

local distances = {}
local d_index = 1
local distance

local cycling = false
local timer = 0

local function dist(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function M.load()
	love.window.setMode(ww, wh)
	love.keyboard.setKeyRepeat(true)

	local x_spacing = sw / (x_count - 1)
	local y_spacing = sh / (y_count - 1)
	local raw_points = {}

	for i = 0, x_count - 1 do
		for j = 0, y_count - 1 do
			table.insert(raw_points, { i, j })
			table.insert(points, { i * x_spacing, j * y_spacing })
		end
	end

	for i = 1, #points do
		for j = i + 1, #points do
			local r1 = raw_points[i]
			local r2 = raw_points[j]
			local p1 = points[i]
			local p2 = points[j]
			local d = ("%f"):format(dist(r1[1], r1[2], r2[1], r2[2]))

			points_by_distance[d] = points_by_distance[d] or {}
			table.insert(points_by_distance[d], p1)
			table.insert(points_by_distance[d], p2)
		end
	end

	for k, _ in pairs(points_by_distance) do
		table.insert(distances, k)
	end

	table.sort(distances, function(a, b)
		return tonumber(a) < tonumber(b)
	end)

	distance = distances[d_index]
end

function M.draw()
	local pts = points_by_distance[distance]
	love.graphics.print(("%05d: distance = %s, %d lines"):format(d_index, distance, #pts / 2))

	if cycling then
		love.graphics.print(("speed: %d/s"):format(speed), 0, wh - 12)
	end

	love.graphics.translate(ox, oy)

	for i = 1, #pts, 2 do
		local p1 = pts[i]
		local p2 = pts[i + 1]
		love.graphics.line(p1[1], p1[2], p2[1], p2[2])
	end

	if draw_points then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setPointSize(2)
		love.graphics.points(points)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function M.update(dt)
	if not cycling then
		return
	end

	timer = timer + dt
	if timer > 1 / speed then
		d_index = d_index % #distances + 1
		distance = distances[d_index]
		timer = timer - 1 / speed
	end
end

function M.keypressed(key)
	if key == "space" then
		cycling = not cycling
	elseif key == "delete" then
		draw_points = not draw_points
	elseif key == "right" then
		s_index = math.min(#speeds, s_index + 1)
	elseif key == "left" then
		s_index = math.max(1, s_index - 1)
	end

	speed = speeds[s_index]

	if cycling then
		return
	end

	if key == "pagedown" then
		d_index = math.min(#distances, d_index + 1)
	elseif key == "pageup" then
		d_index = math.max(1, d_index - 1)
	elseif key == "home" then
		d_index = 1
	elseif key == "end" then
		d_index = #distances
	end

	distance = distances[d_index]
end

return M

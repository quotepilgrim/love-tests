local points = {}
local width, height = 500, 500
local x_count, y_count = 31, 31
local points_by_distance = {}
local distances = {}
local d_index = 1
local distance
local cycling = false
local timer = 0

local function dist(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

local M = {}

function M.load()
	local x_spacing = width / (x_count - 1)
	local y_spacing = height / (y_count - 1)
	for i = 0, x_count - 1 do
		for j = 0, y_count - 1 do
			table.insert(points, { i * x_spacing, j * y_spacing })
		end
	end

	for i = 1, #points do
		for j = i + 1, #points do
			local p1 = points[i]
			local p2 = points[j]
			local d = ("%.4f"):format(dist(p1[1], p1[2], p2[1], p2[2]))

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

	love.graphics.print(("%05d: distance = %s, %d points"):format(d_index, distance, #pts))
	love.graphics.translate(150, 50)
	love.graphics.points(points)

	for i = 1, #pts, 2 do
		local p1 = pts[i]
		local p2 = pts[i + 1]
		love.graphics.line(p1[1], p1[2], p2[1], p2[2])
	end
end

function M.update(dt)
	if not cycling then
		return
	end

	timer = timer + dt
	if timer > 0.5 then
		d_index = d_index % #distances + 1
		distance = distances[d_index]
		timer = timer - 0.5
	end
end

function M.keypressed(key)
	if key == "space" then
		cycling = not cycling
	end

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

local M = {}

local points = {
	{ 100, 300 },
	{ 200, 100 },
	{ 600, 100 },
	{ 700, 300 },
}

local points2 = {
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
}

local points3 = {
	{ 0, 0 },
	{ 0, 0 },
}

local curve = {}

local curve_point = { 0, 0 }

local function lerp(a, b, t)
	return (1 - t) * a + t * b
end

local function distance(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

local t = 0
local selected_point

function M.update(dt)
	t = t + 0.1 * dt
	local mx, my = love.mouse.getX(), love.mouse.getY()

	if t > 1 then
		t = t - 1
		print(#curve)
		curve = {}
	end

	points2[1][1] = lerp(points[1][1], points[2][1], t)
	points2[1][2] = lerp(points[1][2], points[2][2], t)

	points2[2][1] = lerp(points[2][1], points[3][1], t)
	points2[2][2] = lerp(points[2][2], points[3][2], t)

	points2[3][1] = lerp(points[3][1], points[4][1], t)
	points2[3][2] = lerp(points[3][2], points[4][2], t)

	points3[1][1] = lerp(points2[1][1], points2[2][1], t)
	points3[1][2] = lerp(points2[1][2], points2[2][2], t)

	points3[2][1] = lerp(points2[2][1], points2[3][1], t)
	points3[2][2] = lerp(points2[2][2], points2[3][2], t)

	curve_point[1] = lerp(points3[1][1], points3[2][1], t)
	curve_point[2] = lerp(points3[1][2], points3[2][2], t)

	if love.mouse.isDown(1) then
		for _, point in ipairs(points) do
			local x, y = point[1], point[2]
			if distance(mx, my, x, y) < 8 and not selected_point then
				selected_point = point
			end
		end
		if selected_point then
			selected_point[1], selected_point[2] = mx, my
			t = 0
		end
	elseif selected_point then
		selected_point = nil
		curve = {}
	end
	table.insert(curve, { curve_point[1], curve_point[2] })
end

function M.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.points(points)
	if selected_point then
		return
	end
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.points(points2)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.points(points3)
	love.graphics.setPointSize(2)
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.points(curve)
	love.graphics.setPointSize(6)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.points({ curve_point })
end

return M

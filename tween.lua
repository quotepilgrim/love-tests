local M = {}
local PI = math.pi

local tweens = {}

local function ease_in_sine(x)
	return 1 - math.cos(x * PI / 2)
end

local function ease_out_sine(x)
	return math.sin(x * PI / 2)
end

local function ease_in_out_sine(x)
	return -(math.cos(x * PI) - 1) / 2
end

local function ease_in_quad(x)
	return x ^ 2
end

local function ease_out_quad(x)
	return 1 - (1 - x) ^ 2
end

local function ease_in_out_quad(x)
	return x < 0.5 and 2 * x ^ 2 or 1 - (-2 * x + 2) ^ 2 / 2
end

local function ease_out_bounce(x)
	local n1 = 7.5625
	local d1 = 2.75

	if x < 1 / d1 then
		return n1 * x ^ 2
	elseif x < 2 / d1 then
		return n1 * (x - 1.5 / d1) ^ 2 + 0.75
	elseif x < 2.5 / d1 then
		return n1 * (x - 2.25 / d1) ^ 2 + 0.9375
	else
		return n1 * (x - 2.625 / d1) ^ 2 + 0.984375
	end
end

local function ease_in_bounce(x)
	return 1 - ease_out_bounce(1 - x)
end

local function ease_in_out_bounce(x)
	return x < 0.5 and (1 - ease_out_bounce(1 - 2 * x)) / 2 or (1 + ease_out_bounce(2 * x - 1)) / 2
end

local function new_tween(start_t, end_t, time, easing)
	local tween = {}

	tween.start = {}
	tween.object = start_t
	tween.target = end_t
	tween.time = time
	tween.easing = easing or function(x)
		return x
	end
	tween.clock = 0

	for k, _ in pairs(end_t) do
		tween.start[k] = start_t[k]
	end

	return tween
end

local function update_tween(tween, dt)
	tween.clock = tween.clock + dt

	if tween.clock > tween.time then
		tween.clock = tween.time
	end

	for k, v in pairs(tween.target) do
		tween.object[k] = tween.start[k] + tween.easing(tween.clock / tween.time) * (v - tween.start[k])
	end
end

local color = { 1, 0, 0 }

local square = {
	x = 400,
	y = 15,
}

function M.draw()
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", square.x - 5, square.y - 5, 10, 10)
end

function M.update(dt)
	for i = #tweens, 1, -1 do
		update_tween(tweens[i], dt)
		if tweens[i].clock == tweens[i].time then
			table.remove(tweens, i)
		end
	end
end

local swap = false
function M.keypressed(key)
	local easing

	if key == "1" then
		easing = ease_in_sine
	elseif key == "2" then
		easing = ease_out_sine
	elseif key == "3" then
		easing = ease_in_out_sine
	elseif key == "4" then
		easing = ease_in_quad
	elseif key == "5" then
		easing = ease_out_quad
	elseif key == "6" then
		easing = ease_in_out_quad
	elseif key == "7" then
		easing = ease_in_bounce
	elseif key == "8" then
		easing = ease_out_bounce
	elseif key == "9" then
		easing = ease_in_out_bounce
	else
		return
	end

	local target_color = color[1] < 0.5 and { 1, 0, 0 } or { 0, 0.5, 1 }
	table.insert(tweens, new_tween(color, target_color, 2, easing))

	if love.keyboard.isDown("lctrl", "rctrl") then
		return
	end

	if love.keyboard.isDown("lshift", "rshift") then
		square.x = 15
		square.y = 15
		table.insert(tweens, new_tween(square, { x = 400 }, 2))
	else
		square.x = 400
		square.y = 15
	end
	table.insert(tweens, new_tween(square, { y = 300 }, 2, easing))
end

return M

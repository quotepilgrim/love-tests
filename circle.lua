local function new_circle(x, y, r)
	local circle = {}
	circle.x = x or 0
	circle.y = y or 0
	circle.r = r or 10
	return circle
end

local function collide(circle1, circle2)
	local dx = circle2.x - circle1.x
	local dy = circle2.y - circle1.y
	local d_squared = dx * dx + dy * dy
	local r_sum = circle1.r + circle2.r
	return d_squared < (r_sum * r_sum)
end

local function draw_circle(circle)
	love.graphics.circle("fill", circle.x, circle.y, circle.r)
end

local circle1 = new_circle(20, 20, 10)
local circle2 = new_circle(200, 20, 10)
local speed = 100
local white = { 1, 1, 1, 1 }
local red = { 1, 0, 0, 1 }
local color = white

local t = {}

function t.draw()
	love.graphics.setColor(color)
	draw_circle(circle1)
	draw_circle(circle2)
end

function t.update(dt)
	local d = speed * dt
	if love.keyboard.isDown("w") then
		circle1.y = circle1.y - d
	end
	if love.keyboard.isDown("s") then
		circle1.y = circle1.y + d
	end
	if love.keyboard.isDown("a") then
		circle1.x = circle1.x - d
	end
	if love.keyboard.isDown("d") then
		circle1.x = circle1.x + d
	end
	if love.keyboard.isDown("up") then
		circle2.y = circle2.y - d
	end
	if love.keyboard.isDown("down") then
		circle2.y = circle2.y + d
	end
	if love.keyboard.isDown("left") then
		circle2.x = circle2.x - d
	end
	if love.keyboard.isDown("right") then
		circle2.x = circle2.x + d
	end
	if love.keyboard.isDown("q") then
		circle1.r = math.max(1, circle1.r - 1)
	end
	if love.keyboard.isDown("e") then
		circle1.r = math.min(500, circle1.r + 1)
	end
	if love.keyboard.isDown("pageup") then
		circle2.r = math.max(1, circle2.r - 1)
	end
	if love.keyboard.isDown("pagedown") then
		circle2.r = math.min(500, circle2.r + 1)
	end
	if collide(circle1, circle2) then
		color = red
	else
		color = white
	end
end

return t

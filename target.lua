local t = {}

local player = { x = 100, y = 100 }
local enemy = { x = 10, y = 10 }
local target = { x = 0, y = 0 }

local speed = 100

function t.update(dt)
	target.x = player.x * 2 - enemy.x
	target.y = player.y * 2 - enemy.y

	if love.keyboard.isDown("w") then
		enemy.y = enemy.y - speed * dt
	end
	if love.keyboard.isDown("s") then
		enemy.y = enemy.y + speed * dt
	end
	if love.keyboard.isDown("a") then
		enemy.x = enemy.x - speed * dt
	end
	if love.keyboard.isDown("d") then
		enemy.x = enemy.x + speed * dt
	end

	if love.keyboard.isDown("up") then
		player.y = player.y - speed * dt
	end
	if love.keyboard.isDown("down") then
		player.y = player.y + speed * dt
	end
	if love.keyboard.isDown("left") then
		player.x = player.x - speed * dt
	end
	if love.keyboard.isDown("right") then
		player.x = player.x + speed * dt
	end
end

function t.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("fill", player.x, player.y, 5)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.circle("fill", enemy.x, enemy.y, 3)
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle("fill", target.x, target.y, 3)
end

return t

local M = {}

local a = { x = 0, y = 0 }
local b = { x = 0, y = 0 }

local speed = 100

function M.update(dt)
	if love.mouse.isDown(1) then
		a.x = love.mouse.getX()
		a.y = love.mouse.getY()
	end

	b.x = (0.1 * a.x + 0.9 * b.x)
	b.y = (0.1 * a.y + 0.9 * b.y)
end

-- (1 - t) * v0 + t * v1

function M.draw()
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.circle("fill", a.x, a.y, 10)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.circle("fill", b.x, b.y, 10)
	love.graphics.setColor(1, 1, 1, 1)
end

return M

local M = {}
local canvas

function M.load()
	canvas = love.graphics.newCanvas(200, 200)
end

function M.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear(1, 1, 1, 0)
	love.graphics.circle("fill", 100, 100, 96)
	love.graphics.setCanvas()

	love.graphics.draw(canvas)
end

function M.keypressed(key)
	if key == "s" then
		canvas:newImageData():encode("png", "shot.png")
	elseif key == "escape" then
		love.event.quit()
	end
end

return M

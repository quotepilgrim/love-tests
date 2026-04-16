local M = {}
local canvas
local mask, overlay, pattern

function M.load()
	canvas = love.graphics.newCanvas(512, 512)
	mask = love.graphics.newImage("assets/mask.png")
	overlay = love.graphics.newImage("assets/overlay.png")
	pattern = love.graphics.newImage("assets/pattern.png")
end

function M.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear(1, 1, 1, 0)
	love.graphics.draw(mask)
	love.graphics.setBlendMode("add")
	love.graphics.draw(pattern)
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.draw(overlay)
	love.graphics.setCanvas()

	love.graphics.setBlendMode("alpha")
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

local M = {}

local code_data, image_data, image, encoded, decoded

function M.load()
	love.window.setMode(768, 256)
	love.graphics.setDefaultFilter("nearest", "nearest")
	code_data = love.image.newImageData("assets/code.png")
	image_data = love.image.newImageData("assets/image.png")
	image = love.graphics.newImage(image_data)
	local w, h = code_data:getDimensions()
	local decoded_data = love.image.newImageData(w, h)

	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local cr = love.math.colorToBytes(code_data:getPixel(x, y))
			local ir, ig, ib = love.math.colorToBytes(image_data:getPixel(x, y))
			local r = ir - ir % 2 + cr % 2

			image_data:setPixel(x, y, love.math.colorFromBytes(r, ig, ib))
		end
	end

	encoded = love.graphics.newImage(image_data)

	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local r = love.math.colorToBytes(image_data:getPixel(x, y))
			r = r % 2

			decoded_data:setPixel(x, y, r, r, r, 1)
		end
	end

	decoded = love.graphics.newImage(decoded_data)
end

function M.draw()
	love.graphics.scale(2)
	love.graphics.draw(image, 0, 0)
	love.graphics.draw(encoded, 128, 0)
	love.graphics.draw(decoded, 256, 0)
end

function M.keypressed(key)
	if key == "s" then
		image_data:encode("png", "encoded.png")
	end
end

return M

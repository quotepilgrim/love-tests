local M = {}
local frame = {}

function frame:draw()
	local tile_size = self.tilesize
	local image = self.image
	local tiles = self.tiles
	local x = math.ceil(self.x)
	local y = math.ceil(self.y)
	local w = math.ceil(self.w)
	local h = math.ceil(self.h)
	local right = x + w - tile_size
	local bottom = y + h - tile_size

	local tx = x + tile_size
	local ty = y + tile_size

	while tx < right do
		while ty < bottom do
			love.graphics.draw(image, tiles[5], tx, math.min(ty, bottom - tile_size))
			ty = ty + tile_size
		end
		tx = tx + tile_size
		ty = y + tile_size
	end

	tx = x + tile_size
	while tx < right - tile_size do
		love.graphics.draw(image, tiles[2], tx, y)
		love.graphics.draw(image, tiles[8], tx, bottom)
		tx = tx + tile_size
	end

	ty = y + tile_size
	while ty < bottom - tile_size do
		love.graphics.draw(image, tiles[4], x, ty)
		love.graphics.draw(image, tiles[6], right, ty)
		ty = ty + tile_size
	end

	love.graphics.draw(image, tiles[2], right - tile_size, y)
	love.graphics.draw(image, tiles[8], right - tile_size, bottom)
	love.graphics.draw(image, tiles[4], x, bottom - tile_size)
	love.graphics.draw(image, tiles[6], right, bottom - tile_size)

	love.graphics.draw(image, tiles[1], x, y)
	love.graphics.draw(image, tiles[3], right, y)
	love.graphics.draw(image, tiles[7], x, bottom)
	love.graphics.draw(image, tiles[9], right, bottom)
end

function M.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	frame.image = love.graphics.newImage("assets/textbox.png")
	frame.x = 8
	frame.y = 8
	frame.w = 128
	frame.h = 64
	frame.tiles = {}
	local count = 1
	local width = frame.image:getWidth()
	local height = frame.image:getHeight()
	frame.tilesize = width / 3

	for i = 0, 2 do
		for j = 0, 2 do
			frame.tiles[count] = love.graphics.newQuad(
				j * frame.tilesize,
				i * frame.tilesize,
				frame.tilesize,
				frame.tilesize,
				width,
				height
			)
			count = count + 1
		end
	end
end

function M.draw()
	love.graphics.scale(2, 2)
	frame:draw()
end

function M.update(dt)
	local speed = dt * 50
	if love.keyboard.isDown("lshift", "rshift") then
		if love.keyboard.isDown("w", "up") then
			frame.h = math.max(frame.h - speed, frame.tilesize * 2.5)
		end
		if love.keyboard.isDown("s", "down") then
			frame.h = frame.h + speed
		end
		if love.keyboard.isDown("a", "left") then
			frame.w = math.max(frame.w - speed, frame.tilesize * 2.5)
		end
		if love.keyboard.isDown("d", "right") then
			frame.w = frame.w + speed
		end
	else
		if love.keyboard.isDown("w", "up") then
			frame.y = frame.y - speed
		end
		if love.keyboard.isDown("s", "down") then
			frame.y = frame.y + speed
		end
		if love.keyboard.isDown("a", "left") then
			frame.x = frame.x - speed
		end
		if love.keyboard.isDown("d", "right") then
			frame.x = frame.x + speed
		end
	end
end

return M

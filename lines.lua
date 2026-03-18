local M = {}
local lcoords = {}
local rcoords = {}
local tcoords = {}
local dcoords = {}
local ww = 960
local wh = 960
local count = 384
local random = love.math.random

function M.load()
	love.window.setMode(ww, wh)

	local function random_coord(i)
		local h = ww / count * i
		local v = ww / (count * 0.5) * (random() - 0.5)

		return h + v
	end

	for i = 1, count do
		for _, t in ipairs({ rcoords, lcoords, tcoords, dcoords }) do
			table.insert(t, random_coord(i))
		end
	end
end

function M.update() end

function M.draw()
	for i = 1, #lcoords do
		love.graphics.line(0, lcoords[i], ww, rcoords[i])
		love.graphics.line(tcoords[i], 0, dcoords[i], wh)
	end
end

return M

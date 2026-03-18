local m

if arg[2] then
	m = require(arg[2]:gsub("%.lua$", ""))
end

if type(m) == "table" then
	for k, v in pairs(m) do
		love[k] = v
	end

	if not m.keypressed then
		love.keypressed = function(key)
			if key == "escape" then
				love.event.quit()
			end
		end
	end
else
	love.event.quit()
end

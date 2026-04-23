local random = love.math.random

return function(t)
	for i = #t, 2, -1 do
		local j = random(i)
		t[i], t[j] = t[j], t[i]
	end
end

local list = { "a", "b", "c", "d", "e" }

local curr = love.math.random(#list)

for _ = 1, 10 do
	local i = love.math.random(#list - 1)
	curr = (curr + i - 1) % #list + 1
	print(list[curr])
end

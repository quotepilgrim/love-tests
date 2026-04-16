local alphabet = "abcdefghijklmnopqrstuvwxyz"

local function word_gen()
	local word = {}

	while true do
		local i = love.math.random(#alphabet)
		table.insert(word, alphabet:sub(i, i))

		if love.math.random() < 0.2 then
			break
		end
	end

	return table.concat(word)
end

for _ = 1, 10 do
	print(word_gen())
end

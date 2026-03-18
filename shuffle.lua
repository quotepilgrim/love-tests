local cards = {
	"AS",
	"2S",
	"3S",
	"4S",
	"5S",
	"6S",
	"7S",
	"8S",
	"9S",
	"10S",
	"JS",
	"QS",
	"KS",
	"AH",
	"2H",
	"3H",
	"4H",
	"5H",
	"6H",
	"7H",
	"8H",
	"9H",
	"10H",
	"JH",
	"QH",
	"KH",
	"AC",
	"2C",
	"3C",
	"4C",
	"5C",
	"6C",
	"7C",
	"8C",
	"9C",
	"10C",
	"JC",
	"QC",
	"KC",
	"AD",
	"2D",
	"3D",
	"4D",
	"5D",
	"6D",
	"7D",
	"8D",
	"9D",
	"10D",
	"JD",
	"QD",
	"KD",
}

local function shuffle(t)
	for i = #t, 2, -1 do
		local j = love.math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

shuffle(cards)

for i, v in ipairs(cards) do
	io.write(v)
	if i % 4 == 0 then
		io.write("\n")
	else
		io.write(", ")
	end
end

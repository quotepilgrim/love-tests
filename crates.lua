local apples = 66
local crates = {
	{ type = "L", amount = 30 },
	{ type = "M", amount = 12 },
	{ type = "S", amount = 6 },
}
local counts = {}

print(apples)

for _, crate in ipairs(crates) do
	local type, amount = crate.type, crate.amount
	counts[type] = 0
	while apples >= amount do
		counts[type] = counts[type] + 1
		apples = apples - amount
	end
end

for i, c in pairs(crates) do
	io.write(c.type .. ": " .. counts[c.type])
	if i == #crates and apples > 0 then
		io.write(" (+ " .. apples .. ")")
	end
	io.write("\n")
end

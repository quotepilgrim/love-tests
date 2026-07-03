-- solving the homework assignment shown in this video: https://www.youtube.com/watch?v=7X3jG5X4VIs

local function frac(a, b, c)
	return a + b / c
end

local next = require("nextperm")

local digits = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }

local proper = {}
local improper = {}

repeat
	if
		frac(digits[1], digits[2], digits[3]) + frac(digits[4], digits[5], digits[6])
		== frac(digits[7], digits[8], digits[9])
	then
		local s = table.concat(digits, ", ")

		if digits[2] > digits[3] or digits[5] > digits[6] or digits[8] > digits[9] then
			table.insert(improper, s)
		else
			table.insert(proper, s)
		end
	end
until not next(digits)

print(table.concat(improper, "\n"))
print(#improper .. "\n")
print(table.concat(proper, "\n"))
print(#proper .. "\n")

return function(message, key)
	local result = {}
	local a = ("a"):byte()
	key = key:lower():gsub("[^a-z]", "")

	local j = 1
	for i = 1, #message do
		local c = message:sub(i, i)

		if c:match("[a-zA-Z]") then
			local kc = key:sub(j, j)
			local r

			r = (kc:byte() - a - (c:lower():byte() - a)) % 26 + a

			local rc = string.char(r)

			table.insert(result, c:upper() == c and rc:upper() or rc)
			j = j % #key + 1
		else
			table.insert(result, c)
		end
	end

	return table.concat(result)
end

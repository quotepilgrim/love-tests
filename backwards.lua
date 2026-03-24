return function(s)
	local result = {}

	local chars = s:gsub("%s", "")
	local i = #chars

	for j = 1, #s do
		if s:sub(j, j):match("[^%s]") then
			table.insert(result, chars:sub(i, i))
			i = i - 1
		else
			table.insert(result, s:sub(j, j))
		end
	end

	return table.concat(result)
end

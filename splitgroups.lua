return function(s, size)
	local stripped = s:gsub("%s", "")
	local result = {}
	size = size or 5

	assert(size > 0)

	for i = 1, #stripped, size do
		table.insert(result, stripped:sub(i, i + size - 1))
	end

	return table.concat(result, " ")
end

local function copy(t)
	local result = {}

	for i, v in ipairs(t) do
		result[i] = v
	end

	return result
end

return function(n, k)
	local result = {}

	local function backtrack(start, comb)
		if #comb == k then
			table.insert(result, copy(comb))
			return
		end

		for i = start, n do
			table.insert(comb, i)
			backtrack(i + 1, comb)
			table.remove(comb)
		end
	end

	backtrack(1, {})
	return result
end

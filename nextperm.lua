return function(t)
	local i = #t

	while i > 1 and t[i] < t[i - 1] do
		i = i - 1
	end

	if i == 1 then
		return false
	end

	local j = #t
	while t[j] < t[i - 1] do
		j = j - 1
	end

	t[i - 1], t[j] = t[j], t[i - 1]

	j = #t
	while i < j do
		t[i], t[j] = t[j], t[i]
		i = i + 1
		j = j - 1
	end

	return true
end

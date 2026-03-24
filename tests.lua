local backwards = require("backwards")
local split_groups = require("splitgroups")

local str = "the quick brown fox jumps over the lazy dog"
local fmt = "%-16s %s"

print(fmt:format("base string:", str))
print(fmt:format("backwards:", backwards(str)))
print(fmt:format("groups of 4:", split_groups(str, 4)))
print(fmt:format("groups of 5:", split_groups(str)))

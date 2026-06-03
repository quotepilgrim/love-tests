local M = {}
local utf8 = require("utf8")

function utf8.sub(s, i, j)
	i = utf8.offset(s, i)
	j = utf8.offset(s, j) or #s + 1

	return s:sub(i, j - 1)
end

local text = "日本語（にほんご、にっぽんご）は、日本国内や、かつての日本領だった国、そして国外移民や移住"
	.. "者を含む日本人同士の間で使用されている言語。日本は法令によって公用語を規定していないが、法令その"
	.. "他の公用文は全て日本語で記述され、各種法令において日本語を用いることが規定され、学校教育"
	.. "「国語」の教科として学習を行うなど、事実上日本国内において唯一の公用語となっている。"

local font
local timer = 0
local delay = 0.1
local char = 1

function M.load()
	font = love.graphics.newFont("assets/NotoSerifCJKjp-Regular.otf", 24)
	text = table.concat(select(2, font:getWrap(text, 800)), "\n")

	love.graphics.setFont(font)
end

function M.update(dt)
	timer = timer + dt

	while char < #text and timer > delay do
		timer = timer - delay
		char = char + 1
	end
end

function M.draw()
	love.graphics.print(utf8.sub(text, 1, char))
end

return M

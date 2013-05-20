

Input = {} ; Input.__index = Input

function Input.new(text, max, x, y)
	local c = setmetatable({text = text, max = max, x = x, y = y}, Input)

	return c
end

function Input.draw(self)
	love.graphics.setFont(menuFont)
	love.graphics.setColor(snakeGreen) -- green border
	love.graphics.rectangle('fill', self.x, self.y, 140, 100)
	love.graphics.setColor(background) -- blue inside
	love.graphics.rectangle('fill', self.x+5, self.y+5, 130, 90)
	love.graphics.setColor(white) -- white text
	if math.floor(love.timer.getTime()) % 2 == 0 then
		love.graphics.print(self.text, self.x+15, self.y+40)
	else
		love.graphics.print(self.text..'|', self.x+15, self.y+40)
	end
end
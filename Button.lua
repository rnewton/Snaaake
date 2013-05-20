

Button = {} ; Button.__index = Button

function Button.new(text, action, x, y)
	local c = setmetatable({text = text, action = action, x = x, y = y}, Button)

	return c
end

function Button.update(self, dt)
	local mx, my = love.mouse.getPosition()

	if buttonCooldown == 0 and love.mouse.isDown('l') and (self.x <= mx and mx <= self.x + 300) and (self.y <= my and my <= self.y + 100) then
		buttonCooldown = 60
		self.action()
	end
end

function Button.draw(self)
	local mx, my = love.mouse.getPosition()

	love.graphics.setFont(menuFont)

	if (self.x <= mx and mx <= self.x + 300) and (self.y <= my and my <= self.y + 100) then
		love.graphics.setColor(snakeGreen) -- green border
	else
		love.graphics.setColor(nrmlPurple) -- purple border 
	end
	love.graphics.rectangle('fill', self.x, self.y, 300, 100)
	love.graphics.setColor(background) 
	love.graphics.rectangle('fill', self.x+5, self.y+5, 230, 90)
	love.graphics.setColor(white) 
	love.graphics.print(self.text, self.x+15, self.y+40)
end
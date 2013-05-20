GameStates.Paused = GameState.new('Paused')

function GameStates.Paused:draw(self)
	love.mouse.setVisible(true)

	-- title
	love.graphics.setColor(white)
	love.graphics.setFont(titleFont)
	love.graphics.print('Paused', 160, 100)

	-- controls
	love.graphics.setFont(font)
	love.graphics.print('WASD or arrow keys - movement', 165, 200)

	-- buttons
	Buttons[1] = Button.new('resume', resume, 160, 250)
	Buttons[2] = Button.new('main', mainMenu, 210, 350)
	Buttons[3] = Button.new('exit', love.event.quit, 260, 450)
end
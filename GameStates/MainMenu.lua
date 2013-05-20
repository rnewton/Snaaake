GameStates.MainMenu = GameState.new('MainMenu')

function GameStates.MainMenu:draw(self)
	if soundStatus == 'On' then
		love.audio.play(music)
	end

	love.mouse.setVisible(true)

	-- title
	love.graphics.setColor(white)
	love.graphics.setFont(titleFont)
	love.graphics.print('SNAAAKE!', 160, 100)

	-- controls
	love.graphics.setFont(font)
	love.graphics.print('WASD or arrow keys - movement', 165, 200)

	-- buttons
	Buttons[1] = Button.new('start', init, 160, 250)
	Buttons[2] = Button.new('scores', scoreboard, 210, 350)
	Buttons[3] = Button.new('exit', love.event.quit, 260, 450)
end
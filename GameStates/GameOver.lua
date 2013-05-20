GameStates.GameOver = GameState.new('GameOver')

function GameStates.GameOver:draw(self)
	love.mouse.setVisible(true)

	-- title
	love.graphics.setColor(appleRed)
	love.graphics.setFont(titleFont)
	love.graphics.print('Game Over!', 130, 75)

	-- score
	love.graphics.setFont(font)
	-- tally stats
	local apples, applesagainst, tailsfor, tailsagainst, kills = 0, 0, 0, 0, 0
	for k,v in pairs(scores) do
		if v.action == 'apple' and v.snake == 'player' then apples = apples + 1
		elseif v.action == 'apple' and v.snake ~= 'player' then applesagainst = applesagainst + 1
		elseif v.action == 'tail' then tailsfor = tailsfor + 1
		elseif v.action == 'ouch' then tailsagainst = tailsagainst + 1
		else kills = kills + 1 end
	end
	-- display
	love.graphics.setColor(snakeGreen)
	love.graphics.print('Apples Nommed:   '..apples, 45, 175)
	love.graphics.print('Tails Nommed:    '..tailsfor, 45, 200)
	love.graphics.print('KOs:             '..kills, 45, 225)
	love.graphics.print('Level Reached:   '..level, 45, 250)
	love.graphics.setColor(appleRed)
	love.graphics.print('Enemy Noms:      '..applesagainst, 45, 275)
	love.graphics.print('Enemy Tail Noms: '..tailsagainst, 45, 300)
 	love.graphics.setColor(white)
	love.graphics.print('Final Score: '..score, 45, 350)

	-- name entry
	Input.draw(textInput)
	Buttons[1] = Button.new('save', saveScore, 45, 475)

	-- buttons
	Buttons[2] = Button.new('new', init, 450, 200)
	Buttons[3] = Button.new('scores', scoreboard, 400, 300)
	Buttons[4] = Button.new('exit', love.event.quit, 350, 400)
end

function saveScore()
	local entry = {['p']=textInput.text,['s']=score}
	entry = JSON:encode(entry)

	local file = io.open('scores', 'a')
	file:write(entry.."\n")
	file:flush()
	file:close()

	currentScore = score

	state = 'ScoreBoard'
end

function love.keypressed(key, unicode)
    if state == 'GameOver' and textInput ~= nil then 
		if string.len(textInput.text) < textInput.max and unicode > 31 and unicode < 127 then
	        textInput.text = textInput.text .. string.char(unicode)
		elseif key == "backspace" then
			textInput.text = textInput.text:sub(1, #textInput.text - 1)
	    end
	end
end
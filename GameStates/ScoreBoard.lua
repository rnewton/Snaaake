GameStates.ScoreBoard = GameState.new('ScoreBoard')

function GameStates.ScoreBoard:draw(self)
	love.mouse.setVisible(true)

	-- title
	love.graphics.setFont(titleFont)
	love.graphics.print('Scores', 25, 25)

	-- ensure file exists
	local file = io.open('scores', 'rb')
	if file == nil then file = io.open('scores', 'w') ; file:write('') ; file:flush() end
	file:close()

	-- read the lines in table 'lines'
	local lines = {}
	for line in io.lines('scores') do
		decoded = JSON:decode(line)
		table.insert(lines, {decoded.s, decoded.p})
	end
	-- sort
	table.sort(lines, sortScores)

	love.graphics.setFont(font)
	love.graphics.setColor(snakeGreen)
	local y = 100
	local count = 1
	for s,p in pairs(lines) do
		if count <= 10 then 
			if count < 10 then s = ' '..s end
			if currentScore ~= nil and p[1] == currentScore then
				love.graphics.setColor(appleRed)
			else
				love.graphics.setColor(snakeGreen)
			end
			love.graphics.print(s.."     "..p[2].."      "..p[1], 25, y)
			y = y + 50
		end
		count = count + 1
	end

	-- buttons
	Buttons = {}
	Buttons[1] = Button.new('new', init, 500, 200)
	Buttons[2] = Button.new('main', mainMenu, 450, 300)
	Buttons[3] = Button.new('exit', love.event.quit, 400, 400)
end

function sortScores(a, b)
	return a[1] > b[1]
end
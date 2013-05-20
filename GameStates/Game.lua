GameStates.Game = GameState.new('Game')

function GameStates.Game:draw(self)
	love.mouse.setVisible(false)

	-- reset font
	love.graphics.setFont(font)
	
	Snake.draw(player)
	for i=1, table.getn(enemies) do 
		Snake.draw(enemies[i])
	end

	-- draw apple
	love.graphics.setColor(appleRed)
	love.graphics.circle("line", apple.x, apple.y, 5, 30)
	if nommed then 
		love.graphics.print("NOM", apple.x, apple.y)
		nommed = false
		apple = { x = rand:random(30,570), y = rand:random(30,570) }
		transitionBackground(background, backgrounds[rand:random(1,5)])
	end

	-- score & info
	love.graphics.setColor(white)
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
	love.graphics.print("Score: "..score, 10, 25)

	-- level up animation		
	if levelup then
		love.graphics.setFont(titleFont)
		local x = 500 - levelupCool
		love.graphics.print("LEVEL UP!", x, 200)

		levelupCool = levelupCool - 5
		if levelupCool == 0 then levelup = false end
	end
end

function init()
	Buttons = {}
	state = 'Game'
	level = 1
	scoresSeen = {}

	player = Snake.new(100, 300, 4, 'player')
	enemies = {}
	enemies[1] = Snake.new(500, 200, 6, 'easyputer')

	apple = { x = rand:random(30,570), y = rand:random(30,570) }
	nommed = false
	levelup = false
	score = 0
	scores = {}
end

function updateScore(add)
	score = score + add

	if level < 11 and score >= 1000 * level * 2 then
		for _, v in pairs(scoresSeen) do
			if v == score then return end
		end
		table.insert(scoresSeen, score)
		level = level + 1
		print('level = '..level)
		levelupCool = 500;
		levelup = true
		if soundStatus == 'On' then love.audio.play(levelSound) end

		-- add enemies
		for k,v in pairs(levels[level]) do
			if k == 1 and v > 0 then
				for i=1, v do
					print('adding new easyputer')
					table.insert(enemies, Snake.new(rand:random(30,570), rand:random(30,570), rand:random(3,6), 'easyputer')) 
				end
			elseif k == 2 and v > 0 then
				for i=1, v do
					print('adding new normalputer')
					table.insert(enemies, Snake.new(rand:random(30,570), rand:random(30,570), rand:random(3,6), 'normalputer')) 
				end
			elseif k == 3 and v > 0 then
				for i=1, v do
					print('adding new hardputer')
					table.insert(enemies, Snake.new(rand:random(30,570), rand:random(30,570), rand:random(3,6), 'hardputer')) 
				end
			end
		end
	end
end
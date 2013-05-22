require "randomlua"
require("JSON")
require("Snake")
require("Button")
require("Input")
require("GameState")

function love.load()
	-- set up graphics
	w = love.graphics.getWidth()
	h = love.graphics.getHeight()
	font = love.graphics.newFont('Resources/fonts/PressStart2P-Regular.ttf', 16)
	menuFont = love.graphics.newFont('Resources/fonts/PressStart2P-Regular.ttf', 35)
	titleFont = love.graphics.newFont('Resources/fonts/PressStart2P-Regular.ttf', 60)

	-- colors
	snakeGreen = {189,217,94}
	easyPurple = {161,157,179}
	nrmlPurple = {130,112,151}
	hardPurple = {94,76,124}
	appleRed = {254,131,116}
	white = {255,255,255}
	background = {52,110,156}
	backgrounds = {{52,110,156},{26,26,26},{32,32,32},{158,55,0},{11,72,107},{8,56,84}}

	-- set up sounds
	love.audio.setVolume(0.5)
	music = love.audio.newSource('Resources/sounds/DST-InCircles.mp3', 'stream')
	nomSound = love.audio.newSource('Resources/sounds/nom.ogg', 'static')
	nommedSound = love.audio.newSource('Resources/sounds/nommed.ogg', 'static')
	levelSound = love.audio.newSource('Resources/sounds/level.ogg', 'static')
	soundStatus = 'On'

	-- functions
	rand = mwc()
	JSON = (loadfile "JSON.lua")()

	-- levels
	enemies = {}
	levels = {
		[2] = {1,0,0},
		[3] = {0,1,0},
		[4] = {0,0,1},
		[5] = {2,0,0},
		[6] = {1,1,0},
		[7] = {0,2,0},
		[8] = {1,2,0},
		[9] = {2,2,0},
		[10] = {0,0,2},
		[11] = {2,2,2}
	}

	-- player name
	textInput = Input.new('AAA', 3, 85, 375)

	-- game state
	state = 'MainMenu'
	Buttons = {}
	buttonCooldown = 0
end

function love.update(dt)
	buttonCooldown = math.max(0, buttonCooldown - 1)

	-- check loop music
	if soundStatus == 'On' and love.audio.getNumSources() == 0 then
		love.audio.play(music)
	elseif soundStatus == 'Off' then
		love.audio.stop()
	end

	if state == 'Game' then
		-- pause handler
		if love.keyboard.isDown('escape') then
			state = 'paused'
		end

		Snake.update(player, dt)
		for i=1, table.getn(enemies) do 
			Snake.update(enemies[i], dt)
		end
	else
		for i=1, table.getn(Buttons) do
			Button.update(Buttons[i], dt)
		end
	end
end

function transitionBackground(old, new)
	gradient = {}
	for i=1, 5 do
		for j=0, 125 do
			gradient[j+i] = {}
			gradient[j+i][1] = math.min(0, math.max(255, math.floor(old[1]-new[1])))
			gradient[j+i][2] = math.min(0, math.max(255, math.floor(old[2]-new[2])))
			gradient[j+i][3] = math.min(0, math.max(255, math.floor(old[3]-new[3])))
		end
	end
	background = new
end

function love.draw()
	-- Global draw parts
	-- background
	if gradient ~= nil and table.getn(gradient) > 0 then
		local color = table.remove(gradient)
		love.graphics.setBackgroundColor(color)
	else
		love.graphics.setBackgroundColor(background)
	end
	-- audio toggle
	love.graphics.setFont(font)
	love.graphics.print('Sound: '..soundStatus, 625, 15)
	local mx, my = love.mouse.getPosition()
	if buttonCooldown == 0 and love.mouse.isDown('l') and (625 <= mx and mx <= 625 + 200) and (15 <= my and my <= 15 + 15) then
		buttonCooldown = 60
		if soundStatus == 'On' then soundStatus = 'Off' else soundStatus = 'On' end
	end

	-- draw only the visible game state
	GameStates[state]:draw()

	-- draw buttons if they exist
	if Buttons ~= nil then
		for i=1, table.getn(Buttons) do
			Button.draw(Buttons[i])
		end
	end
end
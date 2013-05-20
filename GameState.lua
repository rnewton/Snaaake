GameStates = {}

GameState = {} ; GameState.__index = GameState

function GameState.new(state)
	local c = setmetatable({state = state}, GameState)

	return c
end

function resume()
	state = 'Game'
	print(state)
end

function mainMenu()
	state = 'MainMenu'
	print(state)
end

function scoreboard()
	state = 'ScoreBoard'
	print(state)
end

function gameOver()
	state = 'GameOver'
	print(state)
end

require "GameStates/MainMenu"
require "GameStates/Paused"
require "GameStates/GameOver"
require "GameStates/ScoreBoard"
require "GameStates/Game"
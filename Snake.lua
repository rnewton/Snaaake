

local v = 200 -- velocity
local r = 8 -- radius of segments

Snake = {} ; Snake.__index = Snake

function Snake.new(x, y, length, type)
	local c = setmetatable({[1] = {}, length = length, type = type, wp = {}, wc = 1, respawn = 60, live = true}, Snake)

	c:init(x, y)

	return c
end

function Snake.init(self, x, y)
	self[1] = {x = x, y = y, dir = 0} -- head

	if self.type == 'player' then self.color = snakeGreen 
	elseif self.type == 'easyputer' then self.color = easyPurple 
	elseif self.type == 'normalputer' then self.color = nrmlPurple
	else self.color = hardPurple end 
end

function Snake.update(self, dt)
	if self.live == false then return end

	if self.type == 'player' then
		-- controls
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") and self[1].dir ~= 2 then
			self[1].x = self[1].x - v * dt
			self[1].dir = 0
		elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") and self[1].dir ~= 0 then
			self[1].x = self[1].x + v * dt
			self[1].dir = 2
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") and self[1].dir ~= 3 then
			self[1].y = self[1].y - v * dt
			self[1].dir = 1
		elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") and self[1].dir ~= 1 then
			self[1].y = self[1].y + v * dt
			self[1].dir = 3
		else -- no key, continue previous direction
			if self[1].dir == 0 then self[1].x = self[1].x - v * dt
			elseif self[1].dir == 2 then self[1].x = self[1].x + v * dt
			elseif self[1].dir == 1 then self[1].y = self[1].y - v * dt
			else self[1].y = self[1].y + v * dt end
		end
		shader:send('light_pos', {self[1].x, self[1].y, 0})
	else
		-- set computer bearing towards player's last segment
		if player[player.length-1] ~= nil then
			local dx, dy = self[1].x - player[player.length-1].x, self[1].y - player[player.length-1].y
			self.dir = math.atan2(dy, dx) * 180 / math.pi

			if player.length > 1 and player[player.length] ~= nil then
				local multiplier = 1
				if self.type == 'easyputer' then multiplier = 0.5
				elseif self.type == 'normalputer' then multiplier = 0.85
				else multiplier = 1 end

				local x = player[player.length].x
				local y = player[player.length].y

				for i = 1, self.length do
					if self[i+5] ~= nil then
						if dx + r < self[i+5].x then
							x = x + r*2
						elseif dx > self[i+5].x + r then
							x = x - r*2
						end
						if dy + r < self[i+5].y then
							y = y + r*2
						elseif dy > self[i+5].y + r then
							y = y - r*2
						end
					end
				end

				Snake.moveToPoint(self, x, y, multiplier*v, dt)
			end
		else
			-- start moving somewhere to avoid self collision
			Snake.moveToPoint(self, 100, 300, v, dt)
		end
	end

	-- wrap around map
	if self[1].x < 0 then self[1].x = w end
	if self[1].x > w then self[1].x = 0 end
	if self[1].y < 0 then self[1].y = h end
	if self[1].y > h then self[1].y = 0 end

	-- self way points
	self[1].xv = v*math.cos(self[1].dir)
	self[1].yv = v*math.sin(self[1].dir)

	self.wp[self.wc] = { x = self[1].x, y = self[1].y }
	self.wc = self.wc + 1

	-- trailing dots
	offset = math.floor(110*(love.timer.getFPS()/1000)+0.5)
	for i=1, self.length do
		if self.wp[self.wc-offset*i] ~= nil then
			self[i+1] = { x = self.wp[self.wc-offset*i].x, y = self.wp[self.wc-offset*i].y }
		end
	end

	if self.respawn == 0 then
		-- check collide self
		if self.type == 'player' and self.length > 1 then
			for i = 1, self.length do
				if self[i+5] ~= nil then
					if math.sqrt( (self[1].x - self[i+5].x)^2 + (self[1].y - self[i+5].y)^2 ) < r*2 then
						print('player ran into itself')
						gameOver()
					end		
				end
			end
		end
		-- self check noms
		if math.sqrt( (self[1].x - apple.x)^2 + (self[1].y - apple.y)^2 ) < r*2 then
			nommed = true
			self.length = self.length + 1
			if self.type == 'player' then 
				updateScore(100)
				table.insert(scores,{snake = self.type, action = 'apple'})
			end
			print(self.type..': om nom nom')
			if soundStatus == 'On' then love.audio.play(nomSound) end
		end

		if self.type == 'player' then
			-- check if nommed enemy
			for i=1, table.getn(enemies) do
				local e = enemies[i]
				if e.respawn == 0 and e[e.length] ~= nil then
					if math.sqrt( (self[1].x - e[e.length].x)^2 + (self[1].y - e[e.length].y)^2 ) < r*2 then
						e.respawn = love.timer.getFPS() * 3
						self.length = self.length + 1
						e.length = e.length - 1
						updateScore(250)
						table.insert(scores,{snake = self.type, action = 'tail'})
						print('player nommed '..e.type..'\'s tail')
						if soundStatus == 'On' then love.audio.play(nomSound) end
						if e.length == 1 then 
							e.live = false
							updateScore(500)
							table.insert(scores,{snake = self.type, action = 'kill'})
							print('player finished off '..e.type)
						end
					end
				end	
			end
		else
			-- check if nommed player
			if player.respawn == 0 and player[player.length] ~= nil then
				if math.sqrt( (self[1].x - player[player.length].x)^2 + (self[1].y - player[player.length].y)^2 ) < r*2 then
					player.respawn = love.timer.getFPS() * 3
					self.length = self.length + 1
					player.length = player.length - 1
					updateScore(-150)
					table.insert(scores,{snake = self.type, action = 'ouch'})
					print('player got nommed by '..self.type)
					if soundStatus == 'On' then love.audio.play(nommedSound) end
					if player.length == 1 then 
						gameOver()
					end
				end
			end
		end
	else
		self.respawn = self.respawn - 1
	end

	-- cleanup memory
	self.wp[self.wc-offset*self.length] = nil
end

function Snake.moveToPoint(self, x, y, v, dt)
	if self[1].x > x then self[1].x = self[1].x - v * dt 
	elseif self[1].x <= x then self[1].x = self[1].x + v * dt end
	if self[1].y > y then self[1].y = self[1].y - v * dt 
	elseif self[1].y <= y then self[1].y = self[1].y + v * dt end
end

function Snake.draw(self)
	if self.live == false then return end

	-- respawn timer
	if self.respawn % 10 ~= 0 then 
		love.graphics.setColor(255,255,255)
		love.graphics.print("respawn in..."..self.respawn, self[1].x, self[1].y+r+8)
		return
	end
	love.graphics.setColor(self.color)
	for i = 2, self.length do 
		if self[i] ~= nil then
			love.graphics.circle("fill", self[i].x, self[i].y, r, 30)
		end
	end
	-- head
	love.graphics.circle("fill", self[1].x, self[1].y, r+4, 6)
	love.graphics.setColor(background)
	love.graphics.circle("fill", self[1].x, self[1].y, r, 6)
end
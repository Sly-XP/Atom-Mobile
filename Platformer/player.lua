local enemies = require('enemies')
local coin = require('coins')

function loadPlayer()

	playerT = {}

	local playerCategory = 1
	pAttackTimer = timer.new()

	function spawnPlayer()
		player = {}

 		-- NOTE: hard-coded X-pos so the player doesn't always fall off the map at the start.
		player.body = love.physics.newBody(myWorld, 532, 0, "dynamic")
		player.shape = love.physics.newRectangleShape(48, 48)
		player.fixture = love.physics.newFixture(player.body, player.shape)
		player.fixture:setUserData('player')
		player.fixture:setCategory(playerCategory)
		player.body:setFixedRotation(true)

		player.jumpHeight = -1000
		player.grounded = false
		player.speed = 200
		player.armor = 20
		player.attack = 0
		player.dead = false
		player.attackState = false
		player.defending = false
		player.direction = nil
		player.moving = false
		player.canAttack = true
		player.score = 0

		table.insert(playerT, player)
	end


	playerImage = love.graphics.newImage('assets/LightBandit.png')
	playerGrid = anim8.newGrid(64, 64, playerImage:getWidth(), playerImage:getHeight())


	pA = {}
	pA.idle 			= anim8.newAnimation(playerGrid('1-4',1), 0.15)
	pA.idleFlip 	= anim8.newAnimation(playerGrid('1-4',1), 0.15):flipH()
	pA.defend 		= anim8.newAnimation(playerGrid('5-8',1), 0.15)
	pA.defendFlip = anim8.newAnimation(playerGrid('5-8',1), 0.15):flipH()
	pA.run 				= anim8.newAnimation(playerGrid('1-5',2), 0.07)
	pA.runFlip 		= anim8.newAnimation(playerGrid('1-5',2), 0.07):flipH()

	-- Function in end of both attack animations to make player only attack once
	pA.attack = anim8.newAnimation(playerGrid('2-8',3), 0.05,
		function(x, y)
			for k,v in pairs(enemies.getList()) do
				local distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())
				--[[if player.attackState == true and distanceToPlayer < 64 then
					v.currentHealth = v.currentHealth - player.attack
				end]]
			end
			player.attackState = false
			if currentAnimation == x and player.attackState == false and player.direction == 'left' and player.moving == false then
				currentAnimation = pA.idle
			end
		end
	)

-- Function in end of both attack animations to make player only attack once
	pA.attackFlip = anim8.newAnimation(playerGrid('2-8',3), 0.05,
		function(x,y)
			for k,v in pairs(enemies.getList()) do
				local distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())
			--[[	if player.attackState == true and distanceToPlayer < 64 then
						v.currentHealth = v.currentHealth - player.attack
					end]]
			end
			player.attackState = false
			if currentAnimation == x and player.attackState == false and player.direction == 'right' and player.moving == false then
				currentAnimation = pA.idleFlip
			end
		end
	):flipH()

	pA.jump 		= anim8.newAnimation(playerGrid('4-4',5), 0.1)
	pA.jumpFlip = anim8.newAnimation(playerGrid('4-4',5), 0.1):flipH()

	 currentAnimation = pA.idleFlip

end

function playerMovement(dt)
		if love.keyboard.isScancodeDown('d') then
			player.body:setX(player.body:getX() + player.speed * dt)
			setAnim(pA.runFlip)
			player.direction = 'right'
			player.moving = true
		end
		if love.keyboard.isScancodeDown('a') then
			player.body:setX(player.body:getX() - player.speed * dt)
			setAnim(pA.run)
			player.direction = 'left'
			player.moving = true
		end

		if love.keyboard.isScancodeDown('a') and love.keyboard.isScancodeDown('d') then
			setAnim(pA.idle)
		end

		if player.grounded == false and player.direction == 'right' then
			setAnim(pA.jumpFlip)
		elseif player.grounded == false and player.direction == 'left' then
			setAnim(pA.jump)
		end

		if player.moving == false and currentAnimation == pA.jump	and player.grounded == true then
			setAnim(pA.idle)
		elseif player.moving == false and currentAnimation == pA.jumpFlip and player.grounded == true then
			setAnim(pA.idleFlip)
		end

end

function playerAnimUpdate(dt)
	currentAnimation:update(dt)
	playerDirection()
end

function playerDraw()
	for k,v in pairs(playerT) do
		currentAnimation:draw(playerImage, player.body:getX(), player.body:getY(),	nil, nil, nil, 32, 42)
			local x, y = player.body:getPosition()
			local p = love.graphics.print
			p("Money: " ..player.score, x - 10, y - 50)
	end

end

function love.keypressed(key, scancode, isrepeat)
	if scancode == 'escape' then
		love.event.quit()
	end
	if scancode == 'space' and player.grounded == true then
		player.body:applyLinearImpulse(0, player.jumpHeight)
	end
	if scancode == 's' then
		enemies.spawn(love.mouse.getX() + 32, love.mouse.getY())
	end
	if scancode == 'c' then
		coin.spawn(love.mouse.getX()/2, love.mouse.getY()/2)
	end
end

function love.keyreleased(key, scancode, isrepeat)
	if scancode == "d" then
		setAnim(pA.idleFlip)
		player.moving = false
	end
	if scancode == 'a' then
		setAnim(pA.idle)
		player.moving = false
	end
end

function love.mousereleased(x, y, button, isTouch)
 if button == 1 and player.direction == 'left' then
		setAnim(pA.idle)
	elseif button == 1 and player.direction == 'right' then
		setAnim(pA.idleFlip)
	end

	if button == 2 and player.direction == 'right' then
		player.defending = false
		setAnim(pA.idleFlip)
	elseif button == 2 and player.direction == 'left' then
		player.defending = false
		setAnim(pA.idle)
	end
end

local attackRange = 64

function playerAttack()
	if player.attackState then
		local x, y = player.body:getPosition()
		local enemiesInRange = enemies.getAllWithinDistFrom(attackRange, x, y)
		for i,enemy in ipairs(enemiesInRange) do
			pAttackTimer:after(0.25, function()
					if player.attackState then
						if player.direction == 'right' and enemy.direction == 'left' then
							enemy.currentHealth = enemy.currentHealth - 25
						elseif player.direction == 'left' and enemy.direction == 'right' then
							enemy.currentHealth = enemy.currentHealth - 25
						end
				end
			end)
		end
	end
end


	function love.mousepressed(x, y, button, isTouch)
		if button == 1 and player.direction == 'right' and player.moving == false then
			player.attack = math.random(10, 25)
			player.attackState = true
			setAnim(pA.attackFlip)
			pA.attackFlip:gotoFrame(1)
			playerAttack()
		elseif button == 1 and player.direction == 'left'and player.moving == false then
			player.attack = math.random(10, 25)
			player.attackState = true
			setAnim(pA.attack)
			pA.attack:gotoFrame(1)
			playerAttack()
		end
		if button == 2 and player.direction == 'left' then
			player.defending = true
			setAnim(pA.defend)
		elseif button == 2 and player.direction == 'right' then
			player.defending = true
			setAnim(pA.defendFlip)
		end
	end

	function love.mousereleased(x, y, b, isTouch)
		if b == 1 then
			player.attackState = false
		end
		if b == 2 and player.direction == 'right' then
			player.defending = false
			setAnim(pA.idleFlip)
		elseif b == 2 and player.direction == 'left' then
			player.defending = false
			setAnim(pA.idle)
		end
	end

function playerDirection()
	for k,v in pairs(playerT) do
		local mouseX, width = love.mouse.getX(), love.graphics.getWidth()/2
		if mouseX > width and v.moving == false and v.grounded == true and v.attackState == false and v.defending == false then
			v.direction = 'right'
			setAnim(pA.idleFlip)
		elseif mouseX < width and v.moving == false and v.grounded == true and v.attackState == false and v.defending == false then
			v.direction = 'left'
			setAnim(pA.idle)
		end
	end
end

function setAnim(x)
	currentAnimation = x
end

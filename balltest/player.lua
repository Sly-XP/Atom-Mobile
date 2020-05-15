function loadPlayer()

  playerCategory = 1

  playerT = {}

  function spawnPlayer()
    player = {}

    player.body = love.physics.newBody(myWorld, 0, 0, "dynamic")
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

    table.insert(playerT, player)
  end

  spawnPlayer()

  playerImage = love.graphics.newImage('assets/LightBandit.png')
  playerGrid = anim8.newGrid(64, 64, playerImage:getWidth(), playerImage:getHeight())


  pA = {}
  pA.idle = anim8.newAnimation(playerGrid('1-4',1), 0.15)
  pA.idleFlip = anim8.newAnimation(playerGrid('1-4',1), 0.15):flipH()
  pA.defend = anim8.newAnimation(playerGrid('5-8',1), 0.15)
  pA.defendFlip = anim8.newAnimation(playerGrid('5-8',1), 0.15):flipH()
  pA.run = anim8.newAnimation(playerGrid('1-5',2), 0.07)
  pA.runFlip = anim8.newAnimation(playerGrid('1-5',2), 0.07):flipH()

  -- Function in end of both attack animations to make player only attack once
  pA.attack = anim8.newAnimation(playerGrid('2-8',3), 0.05,
   function(x, y)
     for k,v in pairs(enemy) do
     local distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())
     if player.attackState == true and distanceToPlayer < 64 then
         v.currentHealth = v.currentHealth - player.attack
       end
     end
     player.attackState = false
      if currentAnimation == x and player.attackState == false and player.direction == 'left' and player.moving == false then
        currentAnimation = pA.idle
      end
   end)

-- Function in end of both attack animations to make player only attack once
  pA.attackFlip = anim8.newAnimation(playerGrid('2-8',3), 0.05,
  function(x,y)
  for k,v in pairs(enemy) do
    local distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())
    if player.attackState == true and distanceToPlayer < 64 then
        v.currentHealth = v.currentHealth - player.attack
      end
    end
    player.attackState = false
    if currentAnimation == x and player.attackState == false and player.direction == 'right' and player.moving == false then
      currentAnimation = pA.idleFlip
    end
  end):flipH()

  pA.jump = anim8.newAnimation(playerGrid('4-4',5), 0.1)
  pA.jumpFlip = anim8.newAnimation(playerGrid('4-4',5), 0.1):flipH()

  currentAnimation = pA.idleFlip
end

function playerMovement(dt)
    if love.keyboard.isDown('d') then
      player.body:setX(player.body:getX() + player.speed * dt)
      currentAnimation = pA.runFlip
      player.direction = 'right'
      player.moving = true
    end
    if love.keyboard.isDown('a') then
      player.body:setX(player.body:getX() - player.speed * dt)
      currentAnimation = pA.run
      player.direction = 'left'
      player.moving = true
    end

    if love.keyboard.isDown('a') and love.keyboard.isDown('d') then
      currentAnimation = pA.idle

    end

    if player.grounded == false and player.direction == 'right' then
      currentAnimation = pA.jumpFlip
    elseif player.grounded == false and player.direction == 'left' then
      currentAnimation = pA.jump
    end

    if player.moving == false and currentAnimation == pA.jump  and player.grounded == true then
      currentAnimation = pA.idle
    elseif player.moving == false and currentAnimation == pA.jumpFlip and player.grounded == true then
      currentAnimation = pA.idleFlip
    end

end

function playerAnimUpdate(dt)
  currentAnimation:update(dt)
  playerAttack()
  newCheckAttack()
  playerDirection()

end


function playerDraw()

  for k,v in pairs(playerT) do
    currentAnimation:draw(playerImage, player.body:getX(), player.body:getY(),  nil, nil, nil, 32, 42)
    love.graphics.print('Player X: ' ..v.body:getX(), 10, 20)
    love.graphics.print('Mouse X: ' ..love.mouse.getX(), 10, 40)
    love.graphics.print('Player Attack: ' ..v.attack, 10, 60)
  end

--[[  love.graphics.print("Player Attacking: " ..tostring(player.attackState), 10, 10)
  love.graphics.print("Player Defending: " ..tostring(player.defending), 10 ,30)
  love.graphics.print("Player Moving: " ..tostring(player.moving), 10 ,50)
  love.graphics.print('Player Direction: ' ..tostring(player.direction), 10, 70)
  love.graphics.print('Player Grounded: ' ..tostring(player.grounded), 10, 90)
  love.graphics.print('Timer : ' ..math.floor(timer), 10, 110)]]

end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
  if k == 'space' and player.grounded == true then
    player.body:applyLinearImpulse(0, player.jumpHeight)
  end
  if k == 's' then
    spawnEnemy()
  end
end

function love.keyreleased(k)
  if k == "d" then
    currentAnimation = pA.idleFlip
    player.moving = false
  end
  if k == 'a' then
    currentAnimation = pA.idle
    player.moving = false
  end
end

function love.mousereleased(x, y, button, isTouch)
 if button == 1 and player.direction == 'left' then
    currentAnimation = pA.idle
  elseif button == 1 and player.direction == 'right' then
    currentAnimation = pA.idleFlip
  end

-- Needs fixed, player switches position from regular idle
  if button == 2 and player.direction == 'right' then
    player.defending = false
    currentAnimation = pA.idleFlip
  elseif button == 2 and player.direction == 'left' then
    player.defending = false
    currentAnimation = pA.idle
  end
end

function playerAttack()
  for k,v in pairs(enemy) do
    local distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())
      if distanceToPlayer < 64 and player.attackState == true then
    end
  end
end

function newCheckAttack()
 function love.mousepressed(x, y, button, isTouch)
  if button == 1 and player.direction == 'right' and player.moving == false then
    player.attack = math.random(10, 25)
    player.attackState = true
    currentAnimation = pA.attackFlip
    pA.attackFlip:gotoFrame(1)
  elseif button == 1 and player.direction == 'left'and player.moving == false then
    player.attackState = true
    currentAnimation = pA.attack
    pA.attack:gotoFrame(1)
  end
  if button == 2 and player.direction == 'left' then
    player.defending = true
    currentAnimation = pA.defend
  elseif button == 2 and player.direction == 'right' then
    player.defending = true
    currentAnimation = pA.defendFlip
  end
end

  function love.mousereleased(x, y, b, isTouch)
    if b == 1 then
      player.attackState = false
    end
    if b == 2 and player.direction == 'right' then
      player.defending = false
      currentAnimation = pA.idleFlip
    elseif b == 2 and player.direction == 'left' then
      player.defending = false
      currentAnimation = pA.idle
    end
  end
end

function playerDirection()
  for k,v in pairs(playerT) do
    local mouseX, width = love.mouse.getX(), love.graphics.getWidth()/2
      if mouseX > width and v.moving == false and v.grounded == true and v.attackState == false and v.defending == false then
        v.direction = 'right'
        currentAnimation = pA.idleFlip
      elseif mouseX < width and v.moving == false and v.grounded == true and v.attackState == false and v.defending == false then
        v.direction = 'left'
        currentAnimation = pA.idle
      end
  end
end

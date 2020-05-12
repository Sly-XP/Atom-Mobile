function loadPlayer()

  playerT = {}

  function spawnPlayer()
    player = {}

    player.body = love.physics.newBody(myWorld, 198, 443, "dynamic")
    player.shape = love.physics.newRectangleShape(66, 92)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.body:setFixedRotation(true)
    player.jumpHeight = -2500

    player.grounded = false
    player.x = 100
    player.y = love.graphics.getHeight()/2
    player.speed = 200
    player.armor = 20
    player.attack = math.random(1,25)
    player.dead = false
    player.attackState = false
    player.defending = false
    player.direction = nil
    player.moving = false

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
  pA.run = anim8.newAnimation(playerGrid('1-5',2), 0.1)
  pA.runFlip = anim8.newAnimation(playerGrid('1-5',2), 0.1):flipH()
  pA.attack = anim8.newAnimation(playerGrid('1-8',3), 0.1)
  pA.attackFlip = anim8.newAnimation(playerGrid('1-8',3), 0.1):flipH()
  pA.jump = anim8.newAnimation(playerGrid('4-4',5), 0.1)
  pA.jumpFlip = anim8.newAnimation(playerGrid('4-4',5), 0.1):flipH()

  currentAnimation = pA.idle

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
  pA.idle:update(dt)
  pA.idleFlip:update(dt)
  pA.defend:update(dt)
  pA.defendFlip:update(dt)
  pA.run:update(dt)
  pA.runFlip:update(dt)
  pA.attack:update(dt)
  pA.attackFlip:update(dt)
  pA.jump:update(dt)
  pA.jumpFlip:update(dt)
end


function playerDraw()

  for k,v in pairs(playerT) do
    currentAnimation:draw(playerImage, player.body:getX(), player.body:getY(),  nil, nil, nil, 16, 16)
    --love.graphics.draw(drawable,             x,                 y,               r, sx, sy, ox, oy, kx, ky)
  end

  love.graphics.print("Player Attacking: " ..tostring(player.attackState), 10, 10)
  love.graphics.print("Player Defending: " ..tostring(player.defending), 10 ,30)
  love.graphics.print("Player Moving: " ..tostring(player.moving), 10 ,50)
  love.graphics.print('Player Direction: ' ..tostring(player.direction), 10, 70)
  love.graphics.print('Player Grounded: ' ..tostring(player.grounded), 10, 90)
  love.graphics.print('Timer : ' ..math.floor(timer), 10, 110)


end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
  if k == 'space' and player.grounded == true then
    player.body:applyLinearImpulse(0, player.jumpHeight)
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




function love.mousepressed(x, y, button, isTouch)
  if button == 1 and currentAnimation == pA.idle then
    player.attackState = true
    currentAnimation = pA.attack
  elseif button == 1 and currentAnimation == pA.idleFlip then
    player.attackState = true
    currentAnimation = pA.attackFlip
  end

  if button == 2 and currentAnimation == pA.idle then
    player.defending = true
    currentAnimation = pA.defend
  elseif button == 2 and currentAnimation == pA.idleFlip then
    player.defending = true
    currentAnimation = pA.defendFlip

  end

end

function love.mousereleased(x, y, button, isTouch)
  if button == 1 and currentAnimation == pA.attack then
    player.attackState = false
    currentAnimation = pA.idle
  elseif button == 1 and currentAnimation == pA.attackFlip then
    player.attackState = false
    currentAnimation = pA.idleFlip
  end

-- Needs fixed, player switches position from regular idle
  if button == 2 and currentAnimation == pA.defendFlip then
    player.defending = false
    currentAnimation = pA.idleFlip
  elseif button == 2 and currentAnimation == pA.defend then
    player.defending = false
    currentAnimation = pA.idle

  end
end

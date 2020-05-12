function loadPlayer()

  playerT = {}

  function spawnPlayer()
    player = {}
    player.x = 100
    player.y = love.graphics.getHeight()/2
    player.speed = 200
    player.armor = 20
    player.attack = math.random(1,25)
    player.dead = false
    player.attackState = false
    player.defending = false

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

  currentAnimation = pA.idle

end

function playerMovement(dt)
    if love.keyboard.isDown('d') then
      player.x = player.x + player.speed * dt
      currentAnimation = pA.runFlip
    end
    if love.keyboard.isDown('a') then
      player.x = player.x - player.speed * dt
      currentAnimation = pA.run
    end

    if love.keyboard.isDown('a') and love.keyboard.isDown('d') then
      currentAnimation = pA.idle
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
end


function playerDraw()

  for k,v in pairs(playerT) do
    currentAnimation:draw(playerImage, v.x, v.y)
  end

  love.graphics.print(tostring(player.attackState), 10, 10)
  love.graphics.print(tostring(player.defending), 10 ,30)

end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end

function love.keyreleased(k)
  if k == "d" then
    currentAnimation = pA.idleFlip
  end
  if k == 'a' then
    currentAnimation = pA.idle
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
  if button == 2 then
    player.defending = false
    currentAnimation = pA.idleFlip
  elseif button == 2 and currentAnimation == pA.idle then
    player.defending = false
    currentAnimation = pA.idle

  end
end

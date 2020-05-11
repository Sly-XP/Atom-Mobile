function loadPlayer()

  playerT = {}

  function spawnPlayer()
    player = {}
    player.x = 0
    player.y = 0
    player.speed = 200
    player.armor = 20
    player.attack = math.random(1,25)
    player.dead = false

    table.insert(playerT, player)
  end

  spawnPlayer()

  playerImage = love.graphics.newImage('assets/LightBandit.png')
  playerGrid = anim8.newGrid(64, 64, playerImage:getWidth(), playerImage:getHeight())

  pA = {}
  pA.idle = anim8.newAnimation(playerGrid('1-4',1), 0.15)
  pA.idleFlip = anim8.newAnimation(playerGrid('1-4',1), 0.15):flipH()
  pA.defend = anim8.newAnimation(playerGrid('4-8',1), 0.15)
  pA.run = anim8.newAnimation(playerGrid('1-5',2), 0.1)
  pA.runFlip = anim8.newAnimation(playerGrid('1-5',2), 0.1):flipH()

  currentAnimation = pA.idle

end

function playerMovement(dt)
    if love.keyboard.isDown('w') then
      player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown('d') then
      player.x = player.x + player.speed * dt
      currentAnimation = pA.runFlip
    end
    if love.keyboard.isDown('a') then
      player.x = player.x - player.speed * dt
      currentAnimation = pA.run
    end
    if love.keyboard.isDown('s') then
      player.y = player.y + player.speed * dt
    end
end

function playerAnimUpdate(dt)
  pA.idle:update(dt)
  pA.defend:update(dt)
  pA.run:update(dt)
  pA.runFlip:update(dt)
end


function playerDraw()

  for k,v in pairs(playerT) do
    currentAnimation:draw(playerImage, v.x, v.y)
  end

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

function enemyLoad()

  enemiesCategory = 2

  enemy = {}

  function spawnEnemy()
    enemies = {}

    enemies.body = love.physics.newBody(myWorld, love.mouse.getX() + 32, love.mouse.getY(), "dynamic")
    enemies.shape = love.physics.newCircleShape(20)
    enemies.fixture = love.physics.newFixture(enemies.body, enemies.shape)
    enemies.fixture:setFriction(1)
    enemies.fixture:setCategory(enemiesCategory)
    --enemies.fixture:setMask(playerCategory)
    enemies.fixture:setUserData('enemy')
    enemies.body:setFixedRotation(true)

    enemies.jumping   = false
    enemies.grounded  = false
    enemies.speed     = 100
    enemies.dead      = false
    enemies.currentHealth = 50
    enemies.maxHealth = 50
    enemies.attack    = math.random(1, 25)
    enemies.armor     = math.random(1, 15)
    enemies.attacking = false
    enemies.touchingPlayer = false
    enemies.direction = 'right'
    enemies.isHit     = false

    table.insert(enemy, enemies)
  end

  eA = {}

  enemyImage = love.graphics.newImage('assets/slime.png')
  enemyGrid = anim8.newGrid(64, 64, enemyImage:getWidth(), enemyImage:getHeight())
  eA.healthbar = love.graphics.newImage('assets/slimeHealth.png')
  eA.idle = anim8.newAnimation(enemyGrid('1-4',1), 0.15)
  eA.idleFlip = anim8.newAnimation(enemyGrid('1-4',1), 0.15):flipH()

  eCurrentAnimation = eA.idle

end

function enemyUpdate(dt)
  moveEnemy(dt)
  removeDeadEnemy()
  enemyDirection()
  eCurrentAnimation:update(dt)
  moveEnemy(dt)
  enemyJump()
  moveEnemy(dt)

end

function enemyDraw()
  for k,v in pairs(enemy) do
    eCurrentAnimation:draw(enemyImage, v.body:getX(), v.body:getY(), nil, nil, nil, 32, 48)
    local printl = love.graphics.print
    printl('Enemy Grounded: ' ..tostring(v.grounded), 10, 130)
    printl('Distance to player: ' ..math.floor(distanceToPlayer), 10, 170)
    printl("Touching Enemy: " ..tostring(v.touchingPlayer), 10, 150)
    printl("Enemy jump: ".. tostring(v.jumping), 10, 190)
    printl('Enemy Direction: '.. v.direction, 10, 230)
  end
  drawHealthBar()
end

function drawHealthBar()
  for k,v in pairs(enemy) do
    love.graphics.setColor(1, 0, 0)
    local bodyX, bodyY = v.body:getX()-20, v.body:getY()-40
    love.graphics.rectangle('fill', bodyX, bodyY, 40, 10)
    love.graphics.setColor(1, 1, 1, 1)
    local greenWidth = v.currentHealth / v.maxHealth * 40
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("fill", bodyX, bodyY, greenWidth, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(v.currentHealth, 10, 210)
    love.graphics.draw(eA.healthbar, bodyX- 1, bodyY- 1)
  end
end

function removeDeadEnemy()
  for k,v in pairs(enemy) do
  if v.currentHealth <= 0 then
    v.dead = true
  end
    if v.dead == true then
      v.body:destroy()
      table.remove(enemy, k)
    end
  end
end

function enemyDirection()
  for k,v in pairs(enemy) do
    if player.body:getX() < v.body:getX() then
      v.direction = 'left'
      eCurrentAnimation = eA.idleFlip
    elseif player.body:getX() > v.body:getX() then
      v.direction = 'right'
      eCurrentAnimation = eA.idle
    end
  end
end

function enemyJump()
  for k,v in pairs(enemy) do
    if #enemy >= 1 then
    enemyTimer:after(3,
    function() v.jumping = true
      print('Startjump', v)
      enemyTimer:clear()
      enemyTimer:after(0.00001,
      function() v.jumping = false
        print('EndJump', v)
        enemyTimer:clear() end)
    end)
    end
  end
end

function moveEnemy(dt)
  for k,v in pairs(enemy) do
    local enemyX, enemyY, playerX, playerY = v.body:getX(), v.body:getY(), player.body:getX(), player.body:getY()
    local distanceToPlayer = distanceBetween(playerX, playerY, enemyX, enemyY)
    if v.jumping == true and distanceToPlayer > 64 and v.direction == 'left' and v.grounded == true then
        local xMovement = -distanceToPlayer * 15 * dt
          v.body:applyLinearImpulse(xMovement, -125)
    elseif  v.jumping == true and distanceToPlayer > 64 and v.direction == 'right' and v.grounded == true then
        local xMovement = distanceToPlayer * 15 * dt
        v.body:applyLinearImpulse(xMovement, -125)
    end
  end
end

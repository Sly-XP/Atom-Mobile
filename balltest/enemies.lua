function enemyLoad()

  enemiesCategory = 2

  enemy = {}

  function spawnEnemy()
    enemies = {}

    enemies.body = love.physics.newBody(myWorld, 198, 443, "dynamic")
    enemies.shape = love.physics.newCircleShape(20)
    enemies.fixture = love.physics.newFixture(enemies.body, enemies.shape)
    enemies.fixture:setCategory(enemiesCategory)
    --enemies.fixture:setMask(playerCategory)
    enemies.fixture:setUserData('enemy')
    enemies.body:setFixedRotation(true)

    enemies.jumping = true
    enemies.grounded = false
    enemies.speed    = 100
    enemies.dead     = false
    enemies.currentHealth = 100
    enemies.maxHealth = 100
    enemies.attack   = math.random(1, 25)
    enemies.armor    = math.random(1, 15)
    enemies.attacking = false
    enemies.touchingPlayer = false

    table.insert(enemy, enemies)
  end

spawnEnemy()

end

function enemyUpdate(dt)
  moveEnemy(dt)
  enemyJump()

  removeDeadEnemy()
  for k,v in pairs(enemy) do
    if v.grounded == true and v.jumping == false then
      Timer.after(3, function()
        v.jumping = true
        Timer.after(3, function()
          v.jumping = false
        end)
      end)
    end
  end

end

function enemyDraw()
  for k,v in pairs(enemy) do
    love.graphics.circle('fill', v.body:getX(), v.body:getY(), 20)
    love.graphics.print('Enemy Grounded: ' ..tostring(v.grounded), 10, 130)
    love.graphics.print('Distance to player: ' ..math.floor(distanceToPlayer), 10, 170)
    love.graphics.print("Touching Enemy: " ..tostring(v.touchingPlayer), 10, 150)
    love.graphics.print("Enemy jump: ".. tostring(v.jumping), 10, 190)
  end
  drawHealthBar()
end

function moveEnemy(dt)
  for k,v in pairs(enemy) do
    local enemyX, enemyY, playerX, playerY = v.body:getX(), v.body:getY(), player.body:getX(), player.body:getY()
    distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())

    if distanceToPlayer >= 48 and v.grounded == false then
      if enemyX > playerX and  v.grounded == false then
        v.body:setX(math.floor(enemyX - distanceToPlayer * dt))
      elseif enemyX < playerX  and v.grounded == false then
        v.body:setX(math.floor(enemyX + distanceToPlayer * dt))
      end
    end
  end
end

function drawHealthBar()
  for k,v in pairs(enemy) do
    love.graphics.setColor(1, 0, 0)
    local bodyX, bodyY = v.body:getX()-20, v.body:getY() - 35
    love.graphics.rectangle('fill', bodyX, bodyY, 40, 10)
    love.graphics.setColor(1, 1, 1, 1)

    local greenWidth = v.currentHealth / v.maxHealth * 40

    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("fill", bodyX, bodyY, greenWidth, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(v.currentHealth, 10, 210)
  end
end

function enemyJump()
  for k,v in pairs(enemy) do
    if v.jumping == true and v.grounded == true then
      v.body:applyLinearImpulse(0, -100)
    end
  end
end

function removeDeadEnemy()
  for k,v in pairs(enemy) do
    if v.dead == true then
      v.body:destroy()
      table.remove(enemy, k)
      spawnEnemy()
    end
  end
end

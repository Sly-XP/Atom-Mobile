function enemyLoad()

  enemiesCategory = 2

  enemy = {}

  function spawnEnemy()
    enemies = {}

    enemies.body = love.physics.newBody(myWorld, 198, 443, "dynamic")
    enemies.shape = love.physics.newCircleShape(20)
    enemies.fixture = love.physics.newFixture(enemies.body, enemies.shape)
    enemies.fixture:setCategory(enemiesCategory)
  --  enemies.fixture:setMask(playerCategory)
    enemies.fixture:setUserData('enemy')

    enemies.grounded = false
    enemies.speed = 100
    enemies.dead = false
    enemies.health = 100
    enemies.attack = math.random(1, 25)
    enemies.armor = math.random(1, 15)
    enemies.attacking = false

    table.insert(enemy, enemies)
  end

spawnEnemy()

end

function enemyUpdate(dt)

  moveEnemy(dt)

end

function enemyDraw()

  for k,v in pairs(enemy) do
    love.graphics.circle('fill', v.body:getX(), v.body:getY(), 20)
    love.graphics.print(tostring(v.grounded), 10, 130)
    love.graphics.print(distanceToPlayer, 10, 190)
  end


end

function moveEnemy(dt)
  for k,v in pairs(enemy) do
    local enemyX, enemyY, playerX, playerY = v.body:getX(), v.body:getY(), player.body:getX(), player.body:getY()
    distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), v.body:getX(), v.body:getY())
    if enemyX > playerX then
      v.body:setX(enemyX - distanceToPlayer * dt)
    elseif enemyX < playerX then
      v.body:setX(enemyX + distanceToPlayer * dt)
    end
  end
end

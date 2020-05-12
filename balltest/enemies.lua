function enemyLoad()

  enemy = {}

  function spawnEnemy()
    enemies = {}

    enemies.body = love.physics.newBody(myWorld, 198, 443, "dynamic")
    enemies.shape = love.physics.newCircleShape(20)
    enemies.fixture = love.physics.newFixture(enemies.body, enemies.shape)
    enemies.speed = 100
    enemies.dead = false
    enemies.attacking = false

    table.insert(enemy, enemies)
  end

spawnEnemy()

end

function enemyUpdate(dt)

end

function enemyDraw()

  for k,v in pairs(enemy) do
    love.graphics.circle('fill', v.body:getX(), v.body:getY(), 20)
  end

end

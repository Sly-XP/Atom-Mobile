function love.load()

math.randomseed(os.time())

  ballTable = {}

  function spawnBall()
    ball = {}
    ball.x = math.random(50, 800)
    ball.y = math.random(50, 600)
    ball.vx = 0
    ball.vy = 0
    ball.r = 20
    ball.speed = 200
    ball.dead = false

    table.insert(ballTable, ball)
  end

  function spawnBalls(n)
    for i=1, n do
      spawnBall()
    end
  end

  spawnBalls(100)

ballState = 0
timer = 0

ball.x = ball.x + ball.vx

ball.y = ball.y + ball.vy

end

function love.update(dt)

  timer = timer + dt
  deltaTime = dt

  for k,v in pairs(ballTable) do
    distanceX = love.mouse.getX() - v.x
    distanceY = love.mouse.getY() - v.y
    ballX = v.x
    ballY = v.y
    ballDistance = math.sqrt(ballX^2 + ballY^2)
    distance = math.sqrt(distanceX^2 + distanceY^2)
    angle = math.atan2(distanceY, distanceX)

    local speed = v.speed



    if distance > 50 and ballDistance > 50 then
      v.x = v.x + (math.cos(angle) * distance) * dt
      v.y = v.y + (math.sin(angle) * distance) * dt
    end

  end

end

function love.draw()
  love.graphics.print(tostring(ballState), 10, 10)
  love.graphics.circle('fill', ball.x, ball.y, ball.r)
  love.graphics.print(math.floor(timer), 10, 30)
  love.graphics.print('Distance: '..distance, 10, 50)
  love.graphics.print('Angle: ' ..angle, 10, 70)
  love.graphics.print(deltaTime, 10, 90)

  for k,v in pairs(ballTable) do
    love.graphics.circle("fill", v.x, v.y, v.r)
  end

end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

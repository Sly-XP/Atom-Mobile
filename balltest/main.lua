function love.load()
  math.randomseed(os.time())
  require('player')
  require('namegen/namegen')
  anim8 = require 'anim8'
  require('enemies')
  require('platform')

  myWorld = love.physics.newWorld(0, 500, false)
  myWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

  loadPlayer()
  enemyLoad()

  spawnPlatform(1000, 50, 0, 550)


timer = 0
end

function love.update(dt)
  timer = timer + dt
  playerMovement(dt)
  playerAnimUpdate(dt)
  enemyUpdate(dt)
  myWorld:update(dt)

end

function love.draw()
  playerDraw()
  enemyDraw()
  platformDraw()

end

tunch = false
function beginContact(a, b, coll)
  if a:getUserData() == "player" and b:getUserData() == 'platform' then
    player.grounded = true
  end

  x,y = coll:getNormal()
    if a:getUserData() then
      if b:getUserData() then
        if a:getUserData() == 'player' and b:getUserData() == 'enemy' then
            tunch = true
        end
      end
    end
end

function endContact(a, b, coll)
  if a:getUserData() == "player" and b:getUserData() == 'platform' then
    player.grounded = false
  end
  x,y = coll:getNormal()
    if a:getUserData() then
      if b:getUserData() then
          if a:getUserData() == 'player' and b:getUserData() == 'enemy' then
            tunch = false
      end
    end
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

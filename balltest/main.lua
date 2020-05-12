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

function beginContact(a, b, coll)
  player.grounded = true
end

function endContact(a, b, coll)
  player.grounded = false
end

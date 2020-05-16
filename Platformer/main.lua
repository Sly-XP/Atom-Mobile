io.stdout:setvbuf('no') -- Makes print()s get pushed instantly to whatever terminal you're running in (I use Git Bash).

anim8 = require 'anim8'
sti = require "sti"
timer = require "timer"
cameraFile = require("camera")
require('player')
require('platform')
local enemies = require('enemies')

function love.load()
  math.randomseed(os.time())
  cam = cameraFile()

  gameMap = sti("map/newMap.lua")


  myWorld = love.physics.newWorld(0, 500, false)
  myWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

  for i, obj in pairs(gameMap.layers["Platforms"].objects) do
    spawnPlatform(obj.x, obj.y, obj.width, obj.height)
  end

  loadPlayer()
  enemies.load()

  function frame1(n)
    currentAnimation:gotoFrame(n)
  end
end

function love.update(dt)
  playerMovement(dt)
  playerAnimUpdate(dt)
  enemies.update(dt)
  myWorld:update(dt)
  gameMap:update(dt)
  timer.update(dt)
  cam:lookAt(player.body:getX(), love.graphics.getHeight()/2)
end

function love.draw()
  cam:attach()
  gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
  playerDraw()
  gameMap:drawLayer(gameMap.layers["background"])
  enemies.draw()
  cam:detach()
end

function beginContact(a, b, coll)
  x,y = coll:getNormal()

  local userDataA = a:getUserData()
  local userDataB = b:getUserData()
  if userDataA == 'Platforms' and userDataB == 'player' then
    player.grounded = true
  end
  if a:getUserData() then
    if b:getUserData() then
      if a:getUserData() == 'player' and b:getUserData() == 'enemy' then
        -- Need some way to check WHICH enemy this contact is for.
        local bBody = b:getBody() -- can compare Bodies
        local enemy = enemies.getEnemyMatchingBody(bBody)
        if enemy then
          enemy.touchingPlayer = true
        end
      elseif a:getUserData() == 'Platforms' and b:getUserData() == 'enemy' then
        local bBody = b:getBody()
        local enemy = enemies.getEnemyMatchingBody(bBody)
        if enemy then
          enemy.grounded = true
        end
      end
    end
  end
end

function endContact(a, b, coll)
  x,y = coll:getNormal()
  local userDataA = a:getUserData()
  local userDataB = b:getUserData()
  if userDataA == 'Platforms' and userDataB == 'player' then
    player.grounded = false
  end

  if a:getUserData() then
    if b:getUserData() then
      if a:getUserData() == 'player' and b:getUserData() == 'enemy' then
        local bBody = b:getBody()
        local enemy = enemies.getEnemyMatchingBody(bBody)
        if enemy then
          enemy.touchingPlayer = false
        end
      elseif a:getUserData() == 'Platforms' and b:getUserData() == 'enemy' then
        local bBody = b:getBody()
        local enemy = enemies.getEnemyMatchingBody(bBody)
        if enemy then
          enemy.grounded = false
        end
      end
    end
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

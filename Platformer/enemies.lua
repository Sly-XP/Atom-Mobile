
-- https://love2d.org/forums/memberlist.php?mode=viewprofile&u=139962 Ross is a G

local M = {} -- M for 'Module'. When you require it you give it any name you want, like "enemies".
-- For example: local enemies = require('enemies')
-- Only things that are added to this table can be used by other files.

-- Define variables as local to this file. Nobody else needs to use these.

local enemies = {} -- List of all enemies.
local enemyTimer = timer.new()
local enemyCollisionCategory = 2
local timeBetweenJumps = 3
local jumpForceY = -500
local jumpForceX = 150

-- Assets - actually set in M.load().
local enemyImage
local healthbarImage
local enemyGrid
local idleAnimation

local function jump(enemy)
  local forceX = jumpForceX
  if enemy.direction == 'left' then
    forceX = -forceX
  end
  enemy.body:applyLinearImpulse(forceX, jumpForceY)
end

function M.spawn(x, y) -- Add to the module table, not a global function.
  local enemy = {} -- LOCAL Variable!

  enemy.body = love.physics.newBody(myWorld, x, y, "dynamic")
  enemy.shape = love.physics.newCircleShape(20)
  enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
  enemy.fixture:setFriction(1)
  enemy.fixture:setCategory(enemyCollisionCategory)
  enemy.fixture:setMask(enemyCollisionCategory)
  enemy.fixture:setUserData('enemy')
  enemy.body:setFixedRotation(true)

  enemy.grounded       = false
  enemy.speed          = 25
  enemy.moveForce      = 1000
  enemy.dead           = false
  enemy.currentHealth  = 50
  enemy.maxHealth      = 50
  enemy.attacking      = false
  enemy.touchingPlayer = false
  enemy.direction      = 'right'
  enemy.isHit          = false
  -- Give each enemy its own animation, so they can each act independently.
  enemy.currentAnim    = idleAnimation:clone()
  -- Save the timer handle so we can cancel it on death.
  enemy.jumpTimer      = enemyTimer:every(timeBetweenJumps, function() jump(enemy) end)

  table.insert(enemies, enemy)
end

-- A hack fix to keep your current player code working.
-- See `playerAttack()` in player.lua for how I would handle it normally.
function M.getList()
  return enemies
end

function M.getEnemyMatchingBody(body)
  for i,enemy in ipairs(enemies) do
    if enemy.body == body then
      return enemy
    end
  end
end

function M.getAllWithinDistFrom(dist, x, y)
  local list = {}
  for i,enemy in ipairs(enemies) do
    local distance = distanceBetween(x, y, enemy.body:getPosition())
		if distance < dist then
      table.insert(list, enemy)
    end
  end
  return list
end

function M.load() -- Fill predefined variables with loaded assets.
  enemyImage = love.graphics.newImage('assets/slime.png')
  healthbarImage = love.graphics.newImage('assets/slimeHealth.png')
  enemyGrid = anim8.newGrid(64, 64, enemyImage:getWidth(), enemyImage:getHeight())
  idleAnimation = anim8.newAnimation(enemyGrid('1-4',1), 0.15)
end

local function removeIfDead(enemy, thisEnemyIndex)
  if enemy.currentHealth <= 0 then
    enemy.dead = true
    enemy.body:destroy()
    enemyTimer:cancel(enemy.jumpTimer)
    table.remove(enemies, thisEnemyIndex)
  end
end

local function decideDirection(enemy)
  if player.body:getX() < enemy.body:getX() then
    if enemy.direction ~= 'left' then -- Only flip if it's not already going left.
      enemy.direction = 'left'
      enemy.currentAnim:flipH()
    end
  elseif player.body:getX() > enemy.body:getX() then
    if enemy.direction ~= 'right' then -- Only flip if it's not already going right.
      enemy.direction = 'right'
      enemy.currentAnim:flipH()
    end
  end
end

-- This is no longer needed for jumping. A single impulse at the start of the jump is all you need.
-- I reworked it to make the enemies move along the ground towards the player.
local function move(enemy, dt)
  if enemy.grounded then -- Only move while on the ground.
    local enemyX, enemyY = enemy.body:getPosition()
    local playerX, playerY = player.body:getPosition()
    local distanceToPlayer = distanceBetween(playerX, playerY, enemyX, enemyY)

    enemy.distanceToPlayer = distanceToPlayer -- To print on the screen later - Store this on the enemy instead of making it global.

    if distanceToPlayer > 256 then
      local vx, vy = enemy.body:getLinearVelocity()
      if math.abs(vx) < enemy.speed then
        local xMovement = enemy.moveForce * dt
        if enemy.direction == 'left' then
          xMovement = -xMovement
        end
        enemy.body:applyLinearImpulse(xMovement, 0)
      end
    end
  end
end

function M.update(dt)
  enemyTimer:update(dt)
  for i,enemy in ipairs(enemies) do
    removeIfDead(enemy, i)
    if not enemy.dead then
      decideDirection(enemy)
      enemy.currentAnim:update(dt)
      move(enemy, dt)
    end
  end
end

local function drawHealthBar(enemy)
  love.graphics.setColor(1, 0, 0)
  local bodyX, bodyY = enemy.body:getX()-20, enemy.body:getY()-40
  love.graphics.rectangle('fill', bodyX, bodyY, 40, 10)
  love.graphics.setColor(1, 1, 1, 1)
  local greenWidth = enemy.currentHealth / enemy.maxHealth * 40
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.rectangle("fill", bodyX, bodyY, greenWidth, 10)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(healthbarImage, bodyX - 1, bodyY - 1)
end

function M.draw()
  for i,enemy in ipairs(enemies) do
    -- Draw this enemy.
    local x, y = enemy.body:getPosition()
    local ox, oy = 32, 48 -- image offset X/Y
    enemy.currentAnim:draw(enemyImage, x, y, nil, nil, nil, ox, oy)
    drawHealthBar(enemy)

    -- Debugging info.
    local printl = love.graphics.print
    local textX = 10 + (i - 1) * 150
    love.graphics.setColor(1, 1, 1, 0.7)
    printl(i, textX, 110)
    printl('Enemy Grounded: ' ..tostring(enemy.grounded), textX, 130)
    printl("Touching Enemy: " ..tostring(enemy.touchingPlayer), textX, 150)
    printl('Distance to player: ' ..math.floor(enemy.distanceToPlayer or 0), textX, 170)
    printl('Enemy Direction: '.. enemy.direction, textX, 190)
    love.graphics.print(enemy.currentHealth, textX, 210)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

return M

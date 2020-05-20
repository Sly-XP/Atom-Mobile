

local M = {}
local coins = {}
local coinCollisionCategory = 4
local coinTimer = timer.new()
function M.spawn(x, y)
  local coin = {}
  coin.body = love.physics.newBody(myWorld, x, y, "dynamic")
  coin.shape = love.physics.newCircleShape(8)
  coin.fixture = love.physics.newFixture(coin.body, coin.shape)
  coin.fixture:setFriction(0.5)
  coin.fixture:setCategory(coinCollisionCategory)
  coin.fixture:setMask( 2, 4)
  coin.fixture:setUserData('coin')
  coin.body:setFixedRotation(true)
  coin.x = x
  coin.y = y
  coin.currentAnim = cAnimation:clone()
  coin.collected = false
  coin.direction = 'left'
  coin.distanceToPlayer = distanceBetween(player.body:getX(), player.body:getY(), coin.body:getX(), coin.body:getY())
  local vy = coin.body:applyLinearImpulse(math.random(-100, 150), math.random(-100, -200))
  coin.vy = vy
  coin.timer = coinTimer:after(15, function()   end)

  table.insert(coins, coin)
end

function M.load()
coinSprite = love.graphics.newImage('assets/Coin.png')
coinGrid = anim8.newGrid(8, 8, coinSprite:getWidth(), coinSprite:getHeight())
cAnimation = anim8.newAnimation(coinGrid('1-8',1),  0.08)
end

function M.update(dt)
coinTimer:update(dt)
  for i,coin in pairs(coins) do
    coin.currentAnim:update(dt)
    determineCoinDirection(coin)
    moveCoin(coin, dt)
  end

removeIfCoinDead()
end


function M.draw()
  for k,v in pairs(coins) do
    for i, coin in pairs(coins) do
      coin.currentAnim:draw(coinSprite, v.body:getX(), v.body:getY())
    end
  end
end

function M.getCoinMatchingBody(body)
  for i,coin in ipairs(coins) do
    if coin.body == body then
      return coin
    end
  end
end

function determineCoinDirection(coin)
  local coinX, playerX = coin.body:getX(), player.body:getX()
  if coinX < playerX then
    coin.pos = 'left'
  elseif coinX > playerX then
    coin.pos = 'right'
  end
end

function moveCoin(coin, dt)
  local distance = distanceBetween(coin.body:getX(), coin.body:getY(), player.body:getX(), player.body:getY())
  if coin.collected == false and distance < 192 and coin.pos == 'right' then
    coin.body:setX(coin.body:getX() - coin.distanceToPlayer * dt * 1.2)
  elseif coin.collected == false and distance < 192 and coin.pos == 'left' then
    coin.body:setX(coin.body:getX() + coin.distanceToPlayer * dt * 1.2)
  end
end

function removeIfCoinDead()
  for i=#coins,1,-1 do
  local c = coins[i]
    if c.collected == true then
      c.body:destroy()
    table.remove(coins, i)
    player.score = player.score + 1
    end
  end
end

return M

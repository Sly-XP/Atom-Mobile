

local M = {}
local coins = {}
local coinCollisionCategory = 4
function M.spawn(x, y, vy)
  local coin = {}
  coin.body = love.physics.newBody(myWorld, x, y, "dynamic")
  coin.shape = love.physics.newCircleShape(16)
  coin.fixture = love.physics.newFixture(coin.body, coin.shape)
  coin.fixture:setFriction(0.9)
  coin.fixture:setCategory(coinCollisionCategory)
  coin.fixture:setMask(2, 4)
  coin.fixture:setUserData('coin')
  coin.body:setFixedRotation(true)
  coin.x = x
  coin.y = y
  coin.currentAnim = cAnimation:clone()
  coin.collected = false
  local vy = coin.body:applyLinearImpulse(math.random(-150, 150), math.random(-100, -200))
  coin.vy = vy

  table.insert(coins, coin)
end

function M.load()
coinSprite = love.graphics.newImage('assets/Coin.png')
coinGrid = anim8.newGrid(8, 8, coinSprite:getWidth(), coinSprite:getHeight())
cAnimation = anim8.newAnimation(coinGrid('1-8',1),  0.08)
end

function M.update(dt)
  for i,coin in pairs(coins) do
    coin.currentAnim:update(dt)
  end

  for i=#coins,1,-1 do
  local c = coins[i]
    if c.collected == true then
    table.remove(coins, i)
    player.score = player.score + 1
    end
  end
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


return M

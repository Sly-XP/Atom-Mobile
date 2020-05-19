local M = {}
local floats = {}
local platform = require('platform')
local platformCategory = 3


  function M.spawn(x, y, width, height)
    float = {}
    float.image       = math.randomchoice(floatImages)

    local width = float.image:getWidth()
    local height = float.image:getHeight()

    float.body = love.physics.newBody(myWorld, x, y, "kinematic")
    float.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
    float.fixture = love.physics.newFixture(float.body, float.shape)
    float.fixture:setCategory(platformCategory)
    float.fixture:setUserData('floatingPlatforms')

    local randomFloat = math.random(8, 20)
    local minY = y - randomFloat
    local maxY = y + randomFloat
    local randomSpeed = math.random(8, 15)

    float.x           = float.body:getX()
    float.y           = float.body:getY()
    float.w           = float.image:getWidth()
    float.h           = float.image:getHeight()

    float.maxY        = maxY
    float.minY        = minY
    float.speed       = randomSpeed
    float.top         = false

    table.insert(floats, float)
  end


  function M.load()
    floatImages = {}
    floatImages.a = love.graphics.newImage('assets/float1.png')
    floatImages.b = love.graphics.newImage('assets/float2.png')
    floatImages.c = love.graphics.newImage('assets/float3.png')
    floatImages.d = love.graphics.newImage('assets/float4.png')
  end

  function M.update(dt)
    for i, float in pairs(floats) do
      moveFloat(float, dt)
    end
  end

  function M.draw()
    for i,float in pairs(floats) do
    love.graphics.draw(float.image, float.body:getX(), float.body:getY())
    love.graphics.rectangle('line', float.body:getX(), float.body:getY(), float.w, float.h)
    end

  end

  function moveFloat(float, dt)
    local getY = float.body:getY()
    if getY <= float.minY then
      float.top = true
    elseif getY >= float.maxY then
      float.top = false
    end

    if float.top == false then
      float.body:setY(getY - float.speed * dt)
    elseif float.top == true then
      float.body:setY(getY + float.speed * dt)
    end
  end

  function M.getFloatMatchingBody(body)
    for i,float in ipairs(floats) do
      if float.body == body then
        return float
      end
    end
  end

return M

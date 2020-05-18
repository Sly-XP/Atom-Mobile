local M = {}
local floats = {}



  function M.spawn(x, y, z)
    float = {}

    local randomFloat = math.random(8, 20)
    local randomSpeed = math.random(3, 12)

    local floatY      = y
    local maxY = floatY + randomFloat
    local minY = floatY - randomFloat
    float.x           = x
    float.y           = floatY
    float.maxY        = maxY
    float.minY        = minY
    float.speed       = randomSpeed
    float.image       = math.randomchoice(floatT)
    float.top         = false

    table.insert(floats, float)
  end

  function M.load()
    floatT = {}
    floatT.a = love.graphics.newImage('assets/float1.png')
    floatT.b = love.graphics.newImage('assets/float2.png')
    floatT.c = love.graphics.newImage('assets/float3.png')
    floatT.d = love.graphics.newImage('assets/float4.png')
  end

  function M.update(dt)

    for i, float in pairs(floats) do
      moveFloat(float, dt)
    end

  end

  function M.draw()
    for i,float in pairs(floats) do
      love.graphics.draw(float.image, float.x, float.y)
    end
  end

  function moveFloat(float, dt)
    if float.y <= float.minY then
      float.top = true
    elseif float.y >= float.maxY then
      float.top = false
    end

    if float.top == false then
      float.y = float.y - float.speed * dt
    elseif float.top == true then
      float.y = float.y + float.speed * dt
    end
  end

return M

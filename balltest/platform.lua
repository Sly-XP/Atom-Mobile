platforms = {}

  platformCategory = 3

function spawnPlatform(w, h, x, y)
  platform = {}

  platform.body = love.physics.newBody(myWorld, x, y, "static")
  platform.shape = love.physics.newRectangleShape(w/2, h/2, w, h)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)
  platform.fixture:setCategory(platformCategory)
  platform.fixture:setUserData('platform')
  platform.w = w
  platform.h = h
  platform.x = x
  platform.y = y
  table.insert(platforms, platform)
end

function platformDraw()
  for k,v in pairs(platforms) do
    love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
  end
end

platforms = {}

  platformCategory = 3

  function spawnPlatform(x, y, width, height)
    local platform = {}
    platform.body = love.physics.newBody(myWorld, x, y, "static")
    platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.width = width
    platform.height = height
    platform.fixture:setCategory(platformCategory)
    platform.fixture:setUserData('Platforms')

    table.insert(platforms, platform)
  end

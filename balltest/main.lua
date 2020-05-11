function love.load()
  math.randomseed(os.time())
  require('player')
  require('namegen/namegen')
  anim8 = require 'anim8'

  loadPlayer()



end

function love.update(dt)
  playerMovement(dt)
  
end

function love.draw()
  playerDraw()

end

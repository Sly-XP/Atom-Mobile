function love.load()
  math.randomseed(os.time())
  require('player')

  loadPlayer()



end

function love.update(dt)
  playerMovement(dt)
end

function love.draw()

  playerDraw()

end

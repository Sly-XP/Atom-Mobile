function loadPlayer()

  playerT = {}

  function spawnPlayer()
    player = {}
    player.x = 0
    player.y = 0
    player.speed = 200
    player.armor = 20
    player.attack = math.random(1,25)
    player.dead = false

    table.insert(playerT, player)
  end

  spawnPlayer()

end

function playerMovement(dt)

    if love.keyboard.isDown('w') then
      player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown('d') then
      player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown('a') then
      player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown('s') then
      player.y = player.y + player.speed * dt
    end

end


function playerDraw()

  for k,v in pairs(playerT) do
    love.graphics.circle('fill', v.x, v.y, 20)
  end

end

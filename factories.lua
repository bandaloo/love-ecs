local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600

---@class factories
local factories = {}

---@return Entity
function factories.make_player()
  ---@type Entity
  local player = {}

  player.pos = { x = SCREEN_WIDTH / 2, y = SCREEN_HEIGHT / 2 }
  player.vel = { x = 0, y = 0 }
  player.size = { x = 32, y = 32 }
  player.color = { r = 1, g = 0, b = 0 }
  player.controllable = true

  player.player = true

  return player
end

local PLAYER_BULLET_LIFETIME = 30
local PLAYER_BULLET_SIZE = 16

---@param pos Vec2
---@param vel Vec2
---@return Entity
function factories.make_bullet(pos, vel)
  ---@type Entity
  local bullet = {}

  bullet.pos = { x = pos.x, y = pos.y }

  bullet.vel = { x = vel.x, y = vel.y }

  bullet.lifetime = PLAYER_BULLET_LIFETIME

  bullet.size = { x = PLAYER_BULLET_SIZE, y = PLAYER_BULLET_SIZE }
  bullet.color = { r = 0, g = 1, b = 0 }

  return bullet
end

return factories
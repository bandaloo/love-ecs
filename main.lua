local factories = require "factories"

---@class Vec2
---@field x number
---@field y number

---@class Entity
---@field pos Vec2 | nil
---@field vel Vec2 | nil
---@field acc Vec2 | nil
---@field size Vec2 | nil
---@field color { r: number, g: number, b: number } | nil
---@field lifetime number | nil
---@field controllable true | nil
---@field player true | nil
---@field destroyed true | nil

local player = factories.make_player()

---@type Entity[]
local all_entities = {}

---@type Entity[]
local spawned_entities = {}

local ticks = 0

table.insert(all_entities, player)

---@param entities Entity[]
---@param keyboard_vec Vec2
local function controllable_system(entities, keyboard_vec)
  for _, entity in ipairs(entities) do
    if entity.controllable then
      player.vel.x = keyboard_vec.x
      player.vel.y = keyboard_vec.y
    end
  end
end

---@param entities Entity[]
local function move_system(entities)
  for _, entity in ipairs(entities) do
    if entity.pos and entity.vel then
      if entity.acc then
        entity.vel.x = entity.vel.x + entity.acc.x
        entity.vel.y = entity.vel.y + entity.acc.y
      end

      entity.pos.x = entity.pos.x + entity.vel.x
      entity.pos.y = entity.pos.y + entity.vel.y
    end
  end
end

---@param entities Entity[]
local function draw_system(entities)
  for _, entity in ipairs(entities) do
    if entity.pos and entity.size then
      local color = entity.color or { r = 1, g = 1, b = 1 }
      love.graphics.setColor(color.r, color.g, color.b)
      love.graphics.rectangle(
        "fill",
        entity.pos.x,
        entity.pos.y,
        entity.size.x,
        entity.size.y
      )
    end
  end
end

local PLAYER_FIRE_DELAY = 100

---@param entities Entity[]
local function update_system(entities)
  for _, entity in ipairs(entities) do
    if entity.player and ticks % PLAYER_FIRE_DELAY == 0 then
      assert(entity.pos, "player entity doesn't have position")
      local bullet = factories.make_bullet(entity.pos, { x = 0, y = 3 })
      table.insert(spawned_entities, bullet)
    end
  end
end

---@param entities Entity[]
local function lifetime_system(entities)
  for _, entity in ipairs(entities) do
    if entity.lifetime then
      entity.lifetime = entity.lifetime - 1
      if entity.lifetime <= 0 then
        entity.destroyed = true
      end
    end
  end
end

---@param entities Entity[]
---@return Entity[]
local function destroy_system(entities)
  ---@type Entity[]
  local new_entities = {}
  for _, entity in ipairs(entities) do
    if not entity.destroyed then
      table.insert(new_entities, entity)
    end
  end

  return new_entities
end

local function spawn_entities()
  for _, entity in ipairs(spawned_entities) do
    table.insert(all_entities, entity)
  end

  spawned_entities = {}
end

function love.update()
  local keyboard_x = 0
  local keyboard_y = 0

  if love.keyboard.isDown("a") then
    keyboard_x = keyboard_x - 1
  elseif love.keyboard.isDown("d") then
    keyboard_x = keyboard_x + 1
  end

  if love.keyboard.isDown("s") then
    keyboard_y = keyboard_y + 1
  elseif love.keyboard.isDown("w") then
    keyboard_y = keyboard_y - 1
  end

  controllable_system(all_entities, { x = keyboard_x, y = keyboard_y })
  move_system(all_entities)
  update_system(all_entities)
  lifetime_system(all_entities)

  all_entities = destroy_system(all_entities)
  spawn_entities()

  ticks = ticks + 1
end

function love.draw()
  draw_system(all_entities)
end

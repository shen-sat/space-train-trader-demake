pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

function _init()
  score = 0
  galaxy = {
    x = 0,
    y = 0
  }
  player = {
    sprite = 0,
    x = galaxy.x - 4,
    y = galaxy.y - 4,
    width = 8,
    height = 8,
    speed = 1,
    compass = {0,1,2,3},
    direction = 0,
    speed = 1,
    fuel = 5000,
    carts = {},
    pos_history = {},
    pos_history_limit = 70,
    update = function(self)
      self:update_pos_history()
      self:burn_fuel()
      self:turn()
      self:move()
      self:update_carts_position()
    end,
    update_pos_history = function(self)
     local pos = { x = self.x, y = self.y } 
     add(self.pos_history, pos, 1)
     if #self.pos_history > self.pos_history_limit then
      del(self.pos_history,self.pos_history[#self.pos_history])
     end
    end,
    turn = function(self)
      local rotation
      if self.direction == 0 then
        if btnp(1) then rotation = 1
        elseif btnp(0) then rotation = -1 end
      elseif self.direction == 1 then
        if btnp(3) then rotation = 1
        elseif btnp(2) then rotation = -1 end
      elseif self.direction == 2 then
        if btnp(0) then rotation = 1
        elseif btnp(1) then rotation = -1 end
      else
        if btnp(2) then rotation = 1
        elseif btnp(3) then rotation = -1 end
      end
      self:set_direction(rotation)
    end,
    set_direction = function(self,rotation)
      if rotation == nil then return end

      local new_index = ((self.direction + rotation) % 4) + 1
      self.direction = self.compass[new_index]
    end,
    move = function(self)
      if self.fuel <= 0 then return end

      local movements = {
        [0] = function() self.y -= self.speed end,
        [1] = function() self.x += self.speed end,
        [2] = function() self.y += self.speed end,
        [3] = function() self.x -= self.speed end  
      }
      movements[self.direction]()
    end,
    burn_fuel = function(self)
      self.fuel -= 1
    end,
    update_carts_position = function(self)
      for i, cart in ipairs(self.carts) do
        local cart_pos = self.pos_history[i * cart.width]
        cart.x = cart_pos.x
        cart.y = cart_pos.y
      end
    end
  }

  carts = {
    make_cart(player.x + 20, player.y - 20),
    make_cart(player.x + 30, player.y - 30)
  }
end

function _update()
  player:update()
  for cart in all(carts) do
    cart:check_player_collision(player)
  end
  camera(player.x - 59,player.y - 59)
end

function _draw()
  cls()
  for cart in all(carts) do
    spr(cart.sprite,cart.x,cart.y)
  end
  
  print(#player.pos_history, player.x, player.y + 10, 7)
  spr(player.sprite, player.x, player.y)
  rect(galaxy.x - 63,galaxy.y - 63,127 - 63,127 - 63,7) --border
  pset(galaxy.x,galaxy.y,8) --center of galaxy
end

function check_point_in_rect(point,rect)
  return point.x >= rect.x and point.x <= rect.x + rect.width and point.y >= rect.y and point.y <= rect.y + rect.height
end

function make_cart(x,y)
  local cart = {
    sprite = 1,
    x = x,
    y = y,
    width = 8,
    height = 8,
    type = 'gold',
    is_collected  = false,
    center = function(self)
      local center_points = {
        { x = (self.x + self.width/2), y = (self.y + self.height/2)}, -- bottom right
        { x = (self.x + self.width/2), y = (self.y + self.height/2) - 1}, -- top right
        { x = (self.x + self.width/2) - 1, y = (self.y + self.height/2)}, -- bottom left
        { x = (self.x + self.width/2) - 1, y = (self.y + self.height/2) - 1} -- top left
      }
      return center_points
    end,
    check_player_collision = function(self,player)
      for point in all(self:center()) do
        if check_point_in_rect(point,player) and not self.is_collected then
          self.is_collected = true
          add(player.carts,self)
        end
      end  
    end
  }
  return cart
end

__gfx__
00000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

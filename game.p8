pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

function _init()
  galaxy = {
    x = 0,
    y = 0
  }

  player = {
    sprite = 0,
    x = galaxy.x - 4,
    y = galaxy.y - 4,
    speed = 1,
    compass = {0,1,2,3},
    direction = 0,
    speed = 1,
    update = function(self)
      self:turn()
      self:move()
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
      local movements = {
        [0] = function() self.y -= self.speed end,
        [1] = function() self.x += self.speed end,
        [2] = function() self.y += self.speed end,
        [3] = function() self.x -= self.speed end  
      }
      movements[self.direction]()
    end
  }
end

function _update()
  player:update()

  camera(player.x - 59,player.y - 59)
end

function _draw()
  cls()
  print(player.direction, player.x, player.y + 10, 7)
  spr(player.sprite, player.x, player.y)
  rect(galaxy.x - 63,galaxy.y - 63,127 - 63,127 - 63,7) --border
  pset(galaxy.x,galaxy.y,8) --center of galaxy
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

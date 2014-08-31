local class = require 'src.libs.middleclass'
require 'src.units.MoveableEntity'
Light = class('Light', MoveableEntity)

function Light:initialize(x, y, radius, colour, bbSize)
	MoveableEntity.initialize(
		self, 
		x, 
		y, 
		BoundingBox:new(
			x - (bbSize / 2), 
			y - (bbSize / 2),
			x + (bbSize / 2),
			y + (bbSize / 2)
		)
	)
	self.intensity = 1.0 -- a number between 0 and 1
	self.radius = radius
	self.colour = colour
	self.drawShadows = true -- if true, draws shadows
end

function Light:setIntensity(val)
	if val > 1.0 then 
		val = 1.0
	end
	if val < 0.0 then
		val = 0.0
	end
	self.intensity = val
end

function Light:setDrawShadows(val)
	self.drawShadows = val
end

function Light:update(dt)
	MoveableEntity.update(self, dt)
end

function Light:draw()
	-- Do nothing
	MoveableEntity.draw(self)
end
-- SQUARE
-- Modes: fill, line
local class = require 'src.libs.middleclass'
require 'src.utils.geometry'
require 'src.utils.BoundingBox'
require 'src.units.BaseUnit'
require 'src.units.Light'
Square = class('Square', BaseUnit)

function Square:initialize(x, y, width, height, mode, colorTable)
	BaseUnit.initialize(
		self, 
		x, 
		y, 
		BoundingBox:new(
			x - (width / 2), 
			y - (height / 2),
			x + (width / 2),
			y + (height / 2)
		)
	)
	self.mode = mode
	self.colorTable = colorTable
	self.light = {}
end

function Square:update(dt)
	BaseUnit.update(self, dt)
	self.light.origin = self.origin
end

function Square:addLight(radius, colour)
	self.light = Light:new(self:getX(), self:getY(), radius, colour, 5)
	self.light:setDrawShadows(false)
	self.light:setIntensity(0.4)
	Entities:addLightInstance(self.light)
end

function Square:draw()
	BaseUnit.draw(self)
	if not self.colorTable.a then self.colorTable.a = 255 end
	love.graphics.setColor(self.colorTable.r, self.colorTable.g, self.colorTable.b, self.colorTable.a)
	love.graphics.rectangle(self.mode, self.boundingBox.x1, self.boundingBox.y1, self.boundingBox.width, self.boundingBox.height)
end
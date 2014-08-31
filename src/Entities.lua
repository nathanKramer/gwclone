require 'src.units.square'
require 'src.units.Entity'
require 'src.units.Light'

Entities = {}
Entities.size = 0

-- Key value pairs using the same ID
Entities.GameObjects = {} 
Entities.Lights = {}

function Entities:init()
	World:nRandomLights(20)
	self:addLight(2048, 2048, 200, { 0.8, 0.4, 0.6 })
	self:addSquare(2048, 2549, 50, 50, 'fill', { r = 255, g = 128, b = 128 })
	self:addSquare(1547, 2048, 50, 50, 'fill', { r = 128, g = 255, b = 128 })
	self:addSquare(300, 200, 50, 50, 'fill', { r = 128, g = 128, b = 255 })
end

function Entities:update(dt)
	for e = 0, (Entities.size-1) do
		self[e]:update(dt)
	end
end

function Entities:draw()
	-- love.graphics.setBlendMode('alpha')
	for e = 0, (Entities.size-1) do
		self[e]:draw()
	end
end

function Entities:addSquare(x, y, width, height, mode, colorTable)
	local toAdd = Square:new(x, y, width, height, mode, colorTable)
	toAdd:addLight(700, {0.9, 0.9, 0.9})
	local id = self.size
	self[id] = toAdd
	self.GameObjects[id] = toAdd


	self.size = self.size + 1

	return id
end

function Entities:getObjectPosition(objId)
	return self[objId]:getX(), self[objId]:getY()
end

function Entities:addLight(x, y, radius, colour)
	local toAdd = Light:new(x, y, radius, colour, 5)
	local id = self.size
	self[id] = toAdd
	self.Lights[id] = toAdd


	self.size = self.size + 1

	return id
end

function Entities:addLightInstance(light)
	local id = self.size
	self[id] = light
	self.Lights[id] = light


	self.size = self.size + 1
end
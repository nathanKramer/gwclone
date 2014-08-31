-- The game world
require 'src.utils.shader'
require 'src.units.Light'
require 'src.Entities'

World = {}

function World:init()
	self.width = 4096
	self.height = 4096
	self.cameraStart = { x = self.width/2, y = self.height/2 }
	self.gridScale = 16
	self.gridSquareWidth = self.width/self.gridScale
	self.gridSquareHeight = self.height/self.gridScale
	--self.gridIncrement = 5
end

function World:update(dt)
	-- self.gridScale = self.gridScale + (dt* self.gridIncrement)
	-- if self.gridScale >= 32 then
	-- 	self.gridIncrement = self.gridIncrement * -1
	-- end
	-- self.gridSquareWidth = self.width/self.gridScale
	-- self.gridSquareHeight = self.height/self.gridScale
end

function World:nRandomLights(n)
	for i = 1, n do
		Entities:addLight(love.math.random(0, self.width), love.math.random(0, self.height), love.math.random(300, 800), { love.math.random(), love.math.random(), love.math.random() })
	end
end

function World:draw()
	local mode = love.graphics.getBlendMode()
	love.graphics.setBlendMode('additive')
	love.graphics.setColor({ 100, 100, 250})
	love.graphics.setLineWidth(1)
	for row = 0, self.gridScale do
		local offset = row*self.gridSquareHeight
		love.graphics.line(0, offset, self.width, offset)
	end

	for col = 0, self.gridScale do
		local offset = col*self.gridSquareWidth
		love.graphics.line(offset, 0, offset, self.height)
	end

	love.graphics.setBlendMode(mode)
end
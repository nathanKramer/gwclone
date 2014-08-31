local class = require 'src.libs.middleclass'
require 'src.units.square'
require 'src.utils.BoundingBox'

Hud = {}
Hud.size = 0
Hud.selectionBox = {}
Hud.selectionBox.drawingSelectionBox = false
Hud.selectionBox.lastClicked = {}
Hud.selectionBox.rectangle = nil

local gWidth, gHeight
local borderWidth
local panelSpacing
local cgSquareSize
local cgContainerWidth
local cgContainerHeight
local controlGroupViewX
local controlGroupViewY

function Hud:init()
	gWidth, gHeight = love.graphics.getWidth(), love.graphics.getHeight()
	borderWidth = 10
	panelSpacing = 5
	cgSquareSize = ((gWidth / 10) / 4)
	cgContainerWidth = (cgSquareSize * 10) + (panelSpacing * 11)
	cgContainerHeight = cgSquareSize + (0.25 * cgSquareSize)
	controlGroupViewX = math.floor((gWidth - cgContainerWidth) / 2)
	controlGroupViewY = gHeight - math.floor(cgContainerHeight) - borderWidth
end

function Hud:startSelectionBox(x, y) 
	self.selectionBox.lastClicked = { x = x, y = y }
	self.drawingSelectionBox = true
end

function Hud:endSelectionBox()
	self.drawingSelectionBox = false
end

function Hud:update(dt)

	-- Update selectionbox
	if self.drawingSelectionBox then
		local x = Hud.selectionBox.lastClicked.x
		local y = Hud.selectionBox.lastClicked.y

		local otherX, otherY = camera:mousePosition()

		local rectWidth = math.abs(otherX - x)
		local rectHeight = math.abs(otherY - y)

		local rectX = otherX < x and otherX or x
		local rectY = otherY < y and otherY or y

		local selectionColour = { r = 128, g = 255, b = 128 }
		local innerColour = { r = 128, g = 255, b = 128, a = 64 }
		Hud.selectionBox.square = BoundingBox:new(rectX, rectY, rectX + rectWidth, rectY + rectHeight)
		Hud.selectionBox.rectangle = BoundingBox:new(rectX, rectY, rectX + rectWidth, rectY + rectHeight)
	end
end

function Hud:drawSelectionBox()
	love.graphics.setLineWidth(1)
	if self.drawingSelectionBox then
		local x, y, width, height = 
			Hud.selectionBox.square.x1, 
			Hud.selectionBox.square.y1, 
			Hud.selectionBox.square.width, 
			Hud.selectionBox.square.height
		love.graphics.setColor(128, 255, 128)
		love.graphics.rectangle('line', x, y, width, height )
		love.graphics.setColor(128, 255, 128, 64)
		love.graphics.rectangle('fill', x, y, width, height )
	end
end

-- draws a box for each control group at the bottom of the screen
function Hud:drawControlGroupView()
	local startX, startY = camera:scalePoint(controlGroupViewX, controlGroupViewY)
	love.graphics.setColor(32, 32, 128, 128)
	love.graphics.rectangle('fill', startX, startY, cgContainerWidth, cgContainerHeight)

	for cGroup = 0, 9 do
		panelX = startX + panelSpacing + (cGroup * (panelSpacing + cgSquareSize))
		panelY = startY + panelSpacing

		love.graphics.setColor(153, 153, 255, 255)
		love.graphics.rectangle('line', panelX, panelY, cgSquareSize, cgSquareSize)

		love.graphics.setColor(0, 25, 51)
		love.graphics.rectangle('fill', panelX, panelY, cgSquareSize, cgSquareSize)
		love.graphics.setColor(204, 204, 255, 255)
		cGroup = cGroup + 1
		if cGroup == 10 then cGroup = 0 end
		love.graphics.print(tostring(cGroup), panelX + 2, panelY + 2)

		love.graphics.setColor(164, 164, 255, 192)
		local cg = Game.selection.controlGroups[cGroup]
		local numSelected = cg and cg.selected.size or 0
		love.graphics.print(tostring(numSelected), panelX + (cgSquareSize/2), panelY + (cgSquareSize/2))
	end
end

function Hud:drawHudBorder()
	love.graphics.setColor(32, 32, 128, 128)
	love.graphics.setLineWidth(borderWidth)

	local posX, posY = camera:scalePoint(borderWidth/2, borderWidth/2)
	love.graphics.rectangle('line', posX, posY, gWidth-borderWidth, gHeight-borderWidth)
end

function Hud:draw()
	love.graphics.setBlendMode('alpha')
	Hud:drawSelectionBox()
	Hud:drawControlGroupView()
	Hud:drawHudBorder()

end
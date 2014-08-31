require 'src.selection'
require 'src.utils.camera'

Game = {}
Game.selection = CGSelection:new()

function Game:init()
	World:init()
	Entities:init()
	camera:setBounds(0, 0, World.width, World.height)
	camera:lookAt(World.cameraStart.x, World.cameraStart.y)
	Hud:init()
end

function Game:update(dt)
	World:update(dt)
	GameController:update(dt)
	Entities:update(dt)
	Game:resolveCollisions(dt)
	Hud:update(dt)
end

function Game:resolveCollisions(dt)
	for id, gameObj in pairs(Entities.GameObjects) do
		for id2, gameObj2 in pairs(Entities.GameObjects) do
			if id ~= id2 then
				distance = gameObj.origin:dist(gameObj2.origin)
				if distance < 50 then
					local amountOfOverlap = 50 - distance
					dir = gameObj.origin - gameObj2.origin
					dir:normalize_inplace()
					gameObj.origin = gameObj.origin + (dir * amountOfOverlap / 2)
					gameObj2.origin = gameObj2.origin + (-dir * amountOfOverlap / 2)
				end
			end
		end
	end
end

function Game:draw()
	camera:set()

	Shader:drawLights(Entities.GameObjects, Entities.Lights, World.width, World.height)
	love.graphics.setInvertedStencil(function()
		love.graphics.setColorMask(false, false, false, false)
		Entities:draw()
		love.graphics.setColorMask(true, true, true, true)
	end)
	World:draw()
	love.graphics.setInvertedStencil()
	Entities:draw()


	Hud.draw()

	camera:unset()
end

function Game:centerOnSelected()
	-- Get the current "primary" selection
	local primarySelectedId = Game.selection:getPrimarySelected()
	local newCameraPosX, newCameraPosY = Entities:getObjectPosition(primarySelectedId)
	camera:lookAt(newCameraPosX, newCameraPosY)
end

--
-- Checks if we've selected anything
-- If we have, adds it to the set of selected objects
--
function Game:checkForSelect(pointX, pointY)
	for id, gameObj in pairs(Entities.GameObjects) do

		if gameObj:tryToSelect(pointX, pointY) then
			if not love.keyboard.isDown( "lshift" ) then
				Game:deselectObjects()
			end
			if love.keyboard.isDown( "lctrl" ) then
				Game:selectAllOfType(gameObj.class)
			end
			Game.selection:add(id)
			break
		end
	end
end

function Game:selectAllOfType(c)
	for id, gameObj in pairs(Entities.GameObjects) do
		if gameObj:isInstanceOf(c) then
			Game.selection:add(id)
		end
	end
end

function Game:recallControlGroup(ctrlGroup)
	return Game.selection:recallControlGroup(ctrlGroup)
end

function Game:createControlGroup(ctrlGrp)
	Game.selection:createControlGroup(ctrlGrp)
end

function Game:addToControlGroup(ctrlGrp)
	Game.selection:addToControlGroup(ctrlGrp)
end

--
-- Checks if there are objects to select within the selection box.
-- If there are, adds all of them to the set of selected objects
--
function Game:checkForSelectInBox()

	local selectionBox = Hud.selectionBox.rectangle
	local initialDeselect = true
	for id, gameObj in pairs(Entities.GameObjects) do

		if gameObj:tryToDragSelect(selectionBox) then
			if not love.keyboard.isDown( "lshift" ) and initialDeselect then
				Game:deselectObjects()
				initialDeselect = false
			end
			Game.selection:add(id)
		end
	end

end

function Game:setFocus(state)
	if state then
		mX, mY = love.mouse.getPosition()
		if mX >= 0 and mY >= 0 and mX <= love.graphics.getWidth() and mY <= love.graphics.getHeight() then
			love.mouse.setGrabbed(true)
		end
	end
	self.focus = state
end

function Game:checkForCameraScroll(scrollArea, scrollSpeed)
	if self.focus then
		camera:scroll(scrollArea, scrollSpeed)
	end
end

function Game:deselectObjects()
	Game.selection:deselect(Entities)
end

function Game:clearCommandQueue()

	for id, gameObj in pairs(Entities.GameObjects) do
		if Game.selection.selected[id] then
			gameObj:clearCommandQueue()
		end
	end
end

function Game:moveCommand(x, y)

	for id, gameObj in pairs(Entities.GameObjects) do
		if Game.selection.selected[id] then
			gameObj:addCommandToQueue(MoveCommand:new(x, y))
		end
	end
end

function Game:stopCommand()

	for id, gameObj in pairs(Entities.GameObjects) do
		if Game.selection.selected[id] then
			gameObj:addCommandToQueue(StopCommand:new())
		end
	end
end

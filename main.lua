-- Demo main,lua for WindowScroller
-- Mark Carolan 2010

local scroller = require "windowscroller"

local sceneryFile = "scenery.png"
local imageSlices = 128
local startSlice = 1
local endSlice = 128
local winWidth = 146
-----------------------------

local cabin = display.newImage("cabin.png")
	
local win1 = scroller.newScroller(
	sceneryFile, imageSlices, startSlice, endSlice, winWidth, 
	windowscroller.horiz, 640, 48)

win1.xOrigin = 100
win1.yOrigin = 62

local win2 = scroller.newScroller(
	"squiggle.png", 36, 1, 36, 320, 
	windowscroller.horiz, 360, 20)

win2.xOrigin = 0
win2.yOrigin = cabin.height + win2.height/2 - 20
	
local win3 = scroller.newScroller(
	"squiggle.png", 36, 1, 36, 160, 
	windowscroller.vert, 360, 40)

win3.xOrigin = 96
win3.yOrigin = 80

local prevTime = system.getTimer()	
local speed = 30

local function onFrame(event)
	
	local curTime = system.getTimer()

	if curTime - prevTime >= speed then

		win1:nextFrame()
		win2:prevFrame()
		win3:nextFrame()	
				
		prevTime = curTime
	end	
end

Runtime:addEventListener( "enterFrame", onFrame )
			
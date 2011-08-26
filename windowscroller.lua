-- WindowScroller
-- Mark Carolan 2010
-- Scroll an image 'strip" within a window
-- Warning: no error checking on sprite sheet parameters

module(..., package.seeall)

sprite = require "sprite"

horiz = 1
vert = 2

function newScroller(imageFile, imageSlices, startSlice,
						endSlice, winWidth, dir, imgWidth, imgHeight )
	
	assert(imgWidth > 1)
	assert(imgHeight > 1)
	
	local t = display.newGroup()
	t.seq_start = startSlice
	t.seq_end = endSlice
	t.seq_len = 1 + endSlice-startSlice
	t.slices = imageSlices
	t.window = winWidth
	t.fWidth = imgWidth
	t.fHeight = imgHeight	
	
--[[	-- corona bug #1808 
		-- uncomment and ignore imgWidth, imgHeight params
		-- when bug is fixed
	
	do
		local testFile = display.newImage(imageFile)

		t.fWidth = testFile.width
		t.fHeight = testFile.height

		testFile.isVisible = false
		testFile = nil -- shouldn't be necessary
		
	end
	
--]]

	print(imageFile .. " width, height = " .. t.fWidth .. ", " .. t.fHeight)

	t.slice_size = t.fWidth / t.slices
	
	print("sequence of " .. t.seq_len .. " slices of " .. t.slice_size)
	
	t.sheet = sprite.newSpriteSheet(imageFile, t.slice_size, t.fHeight)
	t.spriteSet = sprite.newSpriteSet(t.sheet, t.seq_start, t.seq_len)	
	
	for i = 1, t.slices do
		local instance = sprite.newSprite(t.spriteSet)
		instance.currentFrame = i
		instance.x = (i-1) * t.slice_size
		if instance.x >= t.window then
			instance.isVisible = false
		end
		t:insert(instance)
	end
	
	function t:setPos(xPos, yPos)
		self.x = xPos
		self.y = yPos
	end

	function t:nextFrame()	
		
		local num_frames = self.numChildren
		local last_frame = self[num_frames]
		for i = num_frames, 2, -1 do
			local f = self[i]
			local prev = self[i-1]
			f.x = prev.x
			f.y = prev.y
			if f.x >= self.window then
				f.isVisible = false
			else
				f.isVisible = true
			end
		end

		local f = self[1]
		f.x = last_frame.x
		f.y = last_frame.y
		if f.x >= self.window then
			f.isVisible = false
		else
			f.isVisible = true
		end		
		
			
	end

	function t:prevFrame()		
		local num_frames = self.numChildren
		local first_frame = self[1]
		for i = 1, num_frames-1 do
			local f = self[i]
			local nxt = self[i+1]
			f.x = nxt.x
			f.y = nxt.y
			if f.x >= self.window then
				f.isVisible = false
			else
				f.isVisible = true
			end
		end

		local f = self[num_frames]
		f.x = first_frame.x
		f.y = first_frame.y
		if f.x >= self.window then
			f.isVisible = false
		else
			f.isVisible = true
		end		
		
			
	end
	
	t.xReference = winWidth/2
	
	if dir == vert then
		t:rotate(90)
	end
	
	return t
end
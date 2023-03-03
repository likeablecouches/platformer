require "entity"
scalingPassage = Entity:extend()

function scalingPassage:new(
	x,
	width,
	finalZoomRatioLeft,
	finalZoomRatioRight)

	self.height = 10^10
	self.finalZoomRatios = {finalZoomRatioLeft, finalZoomRatioRight}
	self.zoomIndex = nil

	self.initialZoomRatio = nil
	self.finalZoomRatio = nil

	self.entrySide = nil

	scalingPassage.super.new(self, x, -self.height / 2, self.height, width)

end

function scalingPassage:detectEntrySide(obj)
	if obj.x + obj.width/2 < self.x + self.width/2  then
		self.entrySide = 'left'
	else
		self.entrySide	= 'right'
	end
end

function scalingPassage:draw()
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

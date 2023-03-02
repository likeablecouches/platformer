require "entity"
scalingPassage = Entity:extend()

function scalingPassage:new(
	x,
	width,
	finalZoomRatioRight,
	finalZoomRatioLeft) -- 1 for in and -1 for out

	self.height = 10^10
	self.finalZoomRatios = {finalZoomRatioLeft, finalZoomRatioRight}
	self.zoomIndex = nil

	self.initialZoomRatio = nil
	self.finalZoomRatio = nil

	self.entryDirection = nil

	scalingPassage.super.new(self, x, -self.height / 2, self.height, width)

end

function scalingPassage:draw()
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

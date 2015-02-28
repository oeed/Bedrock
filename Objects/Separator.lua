Colour = colours.grey
Character = nil

OnDraw = function(self, x, y)
	local char = self.Character
	if not char then
		char = "|"
		if self.Width > self.Height then
			char = '-'
		end
	end
	Drawing.DrawArea(x, y, self.Width, self.Height, char, self.Colour, colours.transparent)
end
Inherit = 'TextBox'
MaskCharacter = '*'

OnDraw = function(self, x, y)
	Drawing.DrawBlankArea(x, y, self.Width, self.Height, self.BackgroundColour)
	if self.CursorPos > #self.Text then
		self.CursorPos = #self.Text
	elseif self.CursorPos < 0 then
		self.CursorPos = 0
	end
	local text = ''

	for i = 1, #self.Text do
		text = text .. self.MaskCharacter
	end

	if self.Bedrock:GetActiveObject() == self then
		if #text > (self.Width - 2) then
			text = text:sub(#text-(self.Width - 3))
			self.Bedrock.CursorPos = {x + 1 + self.Width-2, y}
		else
			self.Bedrock.CursorPos = {x + 1 + self.CursorPos, y}
		end
		self.Bedrock.CursorColour = self.TextColour
	end

	if #tostring(text) == 0 then
		Drawing.DrawCharacters(x + 1, y, self.Placeholder, self.PlaceholderTextColour, self.BackgroundColour)
	else
		if not self.Selected then
			Drawing.DrawCharacters(x + 1, y, text, self.TextColour, self.BackgroundColour)
		else
			for i = 1, #text do
				local char = text:sub(i, i)
				local textColour = self.TextColour
				local backgroundColour = self.BackgroundColour
				if i > self.DragStart and i - 1 <= self.CursorPos then
					textColour = self.SelectedTextColour
					backgroundColour = self.SelectedBackgroundColour
				end
				Drawing.DrawCharacters(x + i, y, char, textColour, backgroundColour)
			end
		end
	end
end

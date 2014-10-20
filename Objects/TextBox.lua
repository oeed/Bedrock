BackgroundColour = colours.lightGrey
SelectedBackgroundColour = colours.blue
SelectedTextColour = colours.white
TextColour = colours.black
PlaceholderTextColour = colours.grey
Placeholder = ''
AutoWidth = false
Text = ""
CursorPos = nil
Numerical = false
DragStart = nil
Selected = false
SelectOnClick = false
ActualDragStart = nil

OnDraw = function(self, x, y)
	Drawing.DrawBlankArea(x, y, self.Width, self.Height, self.BackgroundColour)
	if self.CursorPos > #self.Text then
		self.CursorPos = #self.Text
	elseif self.CursorPos < 0 then
		self.CursorPos = 0
	end
	local text = self.Text
	local offset = self:TextOffset()
	if #text > (self.Width - 2) then
		text = text:sub(offset+1, offset + self.Width - 2)
		-- self.Bedrock.CursorPos = {x + 1 + self.Width-2, y}
	-- else
	end
	if self.Bedrock:GetActiveObject() == self then
		self.Bedrock.CursorPos = {x + 1 + self.CursorPos - offset, y}
		self.Bedrock.CursorColour = self.TextColour
	else
		self.Selected = false
	end

	if #tostring(text) == 0 then
		Drawing.DrawCharacters(x + 1, y, self.Placeholder, self.PlaceholderTextColour, self.BackgroundColour)
	else
		if not self.Selected then
			Drawing.DrawCharacters(x + 1, y, text, self.TextColour, self.BackgroundColour)
		else
			local startPos = self.DragStart - offset
			local endPos = self.CursorPos - offset
			if startPos > endPos then
				startPos = self.CursorPos - offset
				endPos = self.DragStart - offset
			end
			for i = 1, #text do
				local char = text:sub(i, i)
				local textColour = self.TextColour
				local backgroundColour = self.BackgroundColour

				if i > startPos and i - 1 <= endPos then
					textColour = self.SelectedTextColour
					backgroundColour = self.SelectedBackgroundColour
				end
				Drawing.DrawCharacters(x + i, y, char, textColour, backgroundColour)
			end
		end
	end
end

TextOffset = function(self)
	if #self.Text < (self.Width - 2) then
		return 0
	elseif self.Bedrock:GetActiveObject() ~= self then
		return 0
	else
		local textWidth = (self.Width - 2)
		local offset = self.CursorPos - textWidth
		if offset < 0 then
			offset = 0
		end
		return offset
	end
end

OnLoad = function(self)
	if not self.CursorPos then
		self.CursorPos = #self.Text
	end
end

OnClick = function(self, event, side, x, y)
	if self.Bedrock:GetActiveObject() ~= self and self.SelectOnClick then
		self.CursorPos = #self.Text - 1
		self.DragStart = 0
		self.ActualDragStart = x - 2 + self:TextOffset()
		self.Selected = true
	else
		self.CursorPos = x - 2 + self:TextOffset()
		self.DragStart = self.CursorPos
		self.Selected = false
	end
	self.Bedrock:SetActiveObject(self)
end

OnDrag = function(self, event, side, x, y)
	self.CursorPos = x - 2 + self:TextOffset()
	if self.ActualDragStart then
		self.DragStart = self.ActualDragStart
		self.ActualDragStart = nil
	end
	if self.DragStart then
		self.Selected = true
	end
end

OnKeyChar = function(self, event, keychar)
	local deleteSelected = function()
		if self.Selected then
			local startPos = self.DragStart
			local endPos = self.CursorPos
			if startPos > endPos then
				startPos = self.CursorPos
				endPos = self.DragStart
			end
			self.Text = self.Text:sub(1, startPos) .. self.Text:sub(endPos + 2)
			self.CursorPos = startPos
			self.DragStart = nil
			self.Selected = false
			return true
		end
	end

	if event == 'char' then
		deleteSelected()
		if self.Numerical then
			keychar = tostring(tonumber(keychar))
		end
		if keychar == 'nil' then
			return
		end
		self.Text = string.sub(self.Text, 1, self.CursorPos ) .. keychar .. string.sub( self.Text, self.CursorPos + 1 )
		if self.Numerical then
			self.Text = tostring(tonumber(self.Text))
			if self.Text == 'nil' then
				self.Text = '1'
			end
		end
		
		self.CursorPos = self.CursorPos + 1
		if self.OnChange then
			self:OnChange(event, keychar)
		end
		return false
	elseif event == 'key' then
		if keychar == keys.enter then
			if self.OnChange then
				self:OnChange(event, keychar)
			end
		elseif keychar == keys.left then
			-- Left
			if self.CursorPos > 0 then
				if self.Selected then
					self.CursorPos = self.DragStart
					self.DragStart = nil
					self.Selected = false
				else
					self.CursorPos = self.CursorPos - 1
				end
				if self.OnChange then
					self:OnChange(event, keychar)
				end
			end
			
		elseif keychar == keys.right then
			-- Right				
			if self.CursorPos < string.len(self.Text) then
				if self.Selected then
					self.CursorPos = self.CursorPos
					self.DragStart = nil
					self.Selected = false
				else
					self.CursorPos = self.CursorPos + 1
				end
				if self.OnChange then
					self:OnChange(event, keychar)
				end
			end
		
		elseif keychar == keys.backspace then
			-- Backspace
			if not deleteSelected() and self.CursorPos > 0 then
				self.Text = string.sub( self.Text, 1, self.CursorPos - 1 ) .. string.sub( self.Text, self.CursorPos + 1 )
				self.CursorPos = self.CursorPos - 1					
				if self.Numerical then
					self.Text = tostring(tonumber(self.Text))
					if self.Text == 'nil' then
						self.Text = '1'
					end
				end
				if self.OnChange then
					self:OnChange(event, keychar)
				end
			end
		elseif keychar == keys.home then
			-- Home
			self.CursorPos = 0
			if self.OnChange then
				self:OnChange(event, keychar)
			end
		elseif keychar == keys.delete then
			if not deleteSelected() and self.CursorPos < string.len(self.Text) then
				self.Text = string.sub( self.Text, 1, self.CursorPos ) .. string.sub( self.Text, self.CursorPos + 2 )		
				if self.Numerical then
					self.Text = tostring(tonumber(self.Text))
					if self.Text == 'nil' then
						self.Text = '1'
					end
				end
				if self.OnChange then
					self:OnChange(keychar)
				end
			end
		elseif keychar == keys["end"] then
			-- End
			self.CursorPos = string.len(self.Text)
		else
			if self.OnChange then
				self:OnChange(event, keychar)
			end
			return false
		end
	end
end
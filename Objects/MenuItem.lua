BackgroundColour = colours.white
TextColour = colours.black
DisabledTextColour = colours.lightGrey
ShortcutTextColour = colours.grey
Text = ""
Enabled = true
Shortcut = nil
ShortcutPadding = 2
ShortcutName = nil

OnUpdate = function(self, value)
	if value == 'Text' then
		if self.Shortcut then
			self.Width = #self.Text + 2 + self.ShortcutPadding + #self.Shortcut
		else
			self.Width = #self.Text + 2
		end
	elseif value == 'OnClick' then
		self:RegisterShortcut()
	end
end

OnDraw = function(self, x, y)
	Drawing.DrawBlankArea(x, y, self.Width, self.Height, self.BackgroundColour)

	local txt = self.TextColour
	if not self.Enabled then
		txt = self.DisabledTextColour
	end
	Drawing.DrawCharacters(x + 1, y, self.Text, txt, colours.transparent)

	if self.Shortcut then
		local shrt = self.ShortcutTextColour
		if not self.Enabled then
			shrt = self.DisabledTextColour
		end
		Drawing.DrawCharacters(x + self.Width - #self.Shortcut - 1, y, self.Shortcut, shrt, colours.transparent)
	end
end

ParseShortcut = function(self)
	local special = {
		['^'] = keys.leftShift,
		['<'] = keys.delete,
		['>'] = keys.delete,
		['#'] = keys.leftCtrl,
		['~'] = keys.leftAlt,
	}

	local keys = {}
	for i = 1, #self.Shortcut do
	    local c = self.Shortcut:sub(i,i)
    	table.insert(keys, special[c] or c:lower())
	end
	return keys
end

RegisterShortcut = function(self)
	if self.Shortcut then
		self.Shortcut = self.Shortcut:upper()
		self.ShortcutName = self.Bedrock:RegisterKeyboardShortcut(self:ParseShortcut(), function()
			if self.OnClick and self.Enabled then
				if self.Parent.Owner then
					self.Parent:Close()
					self.Parent.Owner.Toggle = true
					self.Bedrock:StartTimer(function()
						self.Parent.Owner.Toggle = false
					end, 0.3)
				end
				return self:OnClick('keyboard_shortcut', 1, 1, 1)
			else
				return false
			end
		end)
	end
end

OnRemove = function(self)
	if self.ShortcutName then
		self.Bedrock:UnregisterKeyboardShortcut(self.ShortcutName)
	end
end

OnLoad = function(self)
	if self.OnClick ~= nil then
		self:RegisterShortcut()
	end
	-- self:OnUpdate('Text')
end
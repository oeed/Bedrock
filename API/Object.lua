X = 1
Y = 1
Width = 1
Height = 1
Parent = nil
OnClick = nil
Visible = true
IgnoreClick = false
Name = nil 
ClipDrawing = true
UpdateDrawBlacklist = {}
Fixed = false
Ready = false

DrawCache = {}

NeedsDraw = function(self)
	if not self.Visible then
		return false
	end
	
	if not self.DrawCache.Buffer or self.DrawCache.AlwaysDraw or self.DrawCache.NeedsDraw then
		return true
	end

	if self.OnNeedsUpdate then
		if self.OnNeedsUpdate() then
			return true
		end
	end

	if self.Children then
		for i, v in ipairs(self.Children) do
			if v:NeedsDraw() then
				return true
			end
		end
	end
end

GetPosition = function(self)
	return self.Bedrock:GetAbsolutePosition(self)
end

GetOffsetPosition = function(self)
	if not self.Parent then
		return {X = 1, Y = 1}
	end

	local offset = {X = 0, Y = 0}
	if not self.Fixed and self.Parent.ChildOffset then
		offset = self.Parent.ChildOffset
	end

	return {X = self.X + offset.X, Y = self.Y + offset.Y}
end

Draw = function(self)
	if not self.Visible then
		return
	end

	self.DrawCache.NeedsDraw = false
	local pos = self:GetPosition()
	Drawing.StartCopyBuffer()

	if self.ClipDrawing then
		Drawing.AddConstraint(pos.X, pos.Y, self.Width, self.Height)
	end

	if self.OnDraw then
		self:OnDraw(pos.X, pos.Y)
	end

	self.DrawCache.Buffer = Drawing.EndCopyBuffer()
	
	if self.Children then
		for i, child in ipairs(self.Children) do
			local pos = child:GetOffsetPosition()
			if pos.Y + self.Height > 1 and pos.Y <= self.Height and pos.X + self.Width > 1 and pos.X <= self.Width then
				child:Draw()
			end
		end
	end


	if self.OnPostChildrenDraw then
		self:OnPostChildrenDraw(pos.X, pos.Y)
	end

	if self.ClipDrawing then
		Drawing.RemoveConstraint()
	end	
end

ForceDraw = function(self, ignoreChildren, ignoreParent, ignoreBedrock)
	if not ignoreBedrock and self.Bedrock then
		self.Bedrock:ForceDraw()
	end
	self.DrawCache.NeedsDraw = true
	if not ignoreParent and self.Parent then
		self.Parent:ForceDraw(true, nil, true)
	end
	if not ignoreChildren and self.Children then
		for i, child in ipairs(self.Children) do
			child:ForceDraw(nil, true, true)
		end
	end
end

OnRemove = function(self)
	if self == self.Bedrock:GetActiveObject() then
		self.Bedrock:SetActiveObject()
	end
end

local function ParseColour(value)
	if type(value) == 'string' then
		if colours[value] and type(colours[value]) == 'number' then
			return colours[value]
		elseif colors[value] and type(colors[value]) == 'number' then
			return colors[value]
		end
	elseif type(value) == 'number' and (value == colours.transparent or (value >= colours.white and value <= colours.black)) then
		return value
	end
	error('Invalid colour: "'..tostring(value)..'"')
end

Initialise = function(self, values)
	local _new = values    -- the new instance
	_new.DrawCache = {
		NeedsDraw = true,
		AlwaysDraw = false,
		Buffer = nil
	}
	setmetatable(_new, {__index = self} )

	local new = {} -- the proxy
	setmetatable(new, {
		__index = function(t, k)
			if k:find('Color') then
				k = k:gsub('Color', 'Colour')
			end

			if k:find('Colour') and type(_new[k]) ~= 'table' and type(_new[k]) ~= 'function' then
				if _new[k] then
					return ParseColour(_new[k])
				end
			elseif _new[k] ~= nil then
				return _new[k]
			end
		end,

		__newindex = function (t,k,v)
			if k:find('Color') then
				k = k:gsub('Color', 'Colour')
			end

			if k == 'Width' or k == 'X' or k == 'Height' or k == 'Y' then
				v = new.Bedrock:ParseStringSize(new.Parent, k, v)
			end

			if v ~= _new[k] then
				_new[k] = v
				if t.OnUpdate then
					t:OnUpdate(k)
				end

				if t.UpdateDrawBlacklist[k] == nil then
					t:ForceDraw()
				end
			end
		end
	})
	if new.OnInitialise then
		new:OnInitialise()
	end

	return new
end

AnimateValue = function(self, valueName, from, to, duration, done, tbl)
	tbl = tbl or self
	if type(tbl[valueName]) ~= 'number' then
		error('Animated value ('..valueName..') must be number.')
	elseif not self.Bedrock.AnimationEnabled then
		tbl[valueName] = to
		if done then
			done()
		end
		return
	end
	from = from or tbl[valueName]
	duration = duration or 0.2
	local delta = to - from

	local startTime = os.clock()
	local previousFrame = startTime
	local frame
	frame = function()
		local time = os.clock()
		local totalTime = time - startTime
		local isLast = totalTime >= duration

		if isLast then
			tbl[valueName] = to
			self:ForceDraw()
			if done then
				done()
			end
		else
			tbl[valueName] = self.Bedrock.Helpers.Round(from + delta * (totalTime / duration))
			self:ForceDraw()
			self.Bedrock:StartTimer(function()
				frame()
			end, 0.05)
		end
	end
	frame()
end

Click = function(self, event, side, x, y)
	if self.Visible and not self.IgnoreClick then
		if event == 'mouse_click' and self.OnClick and self:OnClick(event, side, x, y) ~= false then
			return true
		elseif event == 'mouse_drag' and self.OnDrag and self:OnDrag(event, side, x, y) ~= false then
			return true
		elseif event == 'mouse_scroll' and self.OnScroll and self:OnScroll(event, side, x, y) ~= false then
			return true
		else
			return false
		end
	else
		return false
	end

end

ToggleMenu = function(self, name, x, y)
	return self.Bedrock:ToggleMenu(name, self, x, y)
end

function OnUpdate(self, value)
	if value == 'Z' then
		self.Bedrock:ReorderObjects()
	end
end
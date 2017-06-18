local round = function(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local _w, _h = term.getSize()
local copyBuffer = nil

Screen = {
	Width = _w,
	Height = _h
}

Constraints = {
	
}

CurrentConstraint = {1,1,_w,_h}
IgnoreConstraint = false

function AddConstraint(x, y, width, height)
	local x2 = x + width - 1
	local y2 = y + height - 1
	table.insert(Constraints, {x, y, x2, y2})
	GetConstraint()
end

function RemoveConstraint()
	--table.remove(Constraints, #Constraints)
	Constraints[#Constraints] = nil
	GetConstraint()
end

function GetConstraint()
	local x = 1
	local y = 1
	local x2 = Screen.Width
	local y2 = Screen.Height
	for i, c in ipairs(Constraints) do
		if x < c[1] then
			x = c[1]
		end
		if y < c[2] then
			y = c[2]
		end
		if x2 > c[3] then
			x2 = c[3]
		end
		if y2 > c[4] then
			y2 = c[4]
		end
	end
	CurrentConstraint = {x, y, x2, y2}
end

function WithinContraint(x, y)
	return IgnoreConstraint or
		  (x >= CurrentConstraint[1] and
		   y >= CurrentConstraint[2] and
		   x <= CurrentConstraint[3] and
		   y <= CurrentConstraint[4])
end

colours.transparent = 0
colors.transparent = 0

Filters = {
	None = {
		[colours.white] = colours.white,
		[colours.orange] = colours.orange,
		[colours.magenta] = colours.magenta,
		[colours.lightBlue] = colours.lightBlue,
		[colours.yellow] = colours.yellow,
		[colours.lime] = colours.lime,
		[colours.pink] = colours.pink,
		[colours.grey] = colours.grey,
		[colours.lightGrey] = colours.lightGrey,
		[colours.cyan] = colours.cyan,
		[colours.purple] = colours.purple,
		[colours.blue] = colours.blue,
		[colours.brown] = colours.brown,
		[colours.green] = colours.green,
		[colours.red] = colours.red,
		[colours.black] = colours.black,
		[colours.transparent] = colours.transparent,
	},

	Greyscale = {
		[colours.white] = colours.white,
		[colours.orange] = colours.lightGrey,
		[colours.magenta] = colours.lightGrey,
		[colours.lightBlue] = colours.lightGrey,
		[colours.yellow] = colours.lightGrey,
		[colours.lime] = colours.lightGrey,
		[colours.pink] = colours.lightGrey,
		[colours.grey] = colours.grey,
		[colours.lightGrey] = colours.lightGrey,
		[colours.cyan] = colours.grey,
		[colours.purple] = colours.grey,
		[colours.blue] = colours.grey,
		[colours.brown] = colours.grey,
		[colours.green] = colours.grey,
		[colours.red] = colours.grey,
		[colours.black] = colours.black,
		[colours.transparent] = colours.transparent,
	},

	BlackWhite = {
		[colours.white] = colours.white,
		[colours.orange] = colours.white,
		[colours.magenta] = colours.white,
		[colours.lightBlue] = colours.white,
		[colours.yellow] = colours.white,
		[colours.lime] = colours.white,
		[colours.pink] = colours.white,
		[colours.grey] = colours.black,
		[colours.lightGrey] = colours.white,
		[colours.cyan] = colours.black,
		[colours.purple] = colours.black,
		[colours.blue] = colours.black,
		[colours.brown] = colours.black,
		[colours.green] = colours.black,
		[colours.red] = colours.black,
		[colours.black] = colours.black,
		[colours.transparent] = colours.transparent,
	},

	Darker = {
		[colours.white] = colours.lightGrey,
		[colours.orange] = colours.red,
		[colours.magenta] = colours.purple,
		[colours.lightBlue] = colours.cyan,
		[colours.yellow] = colours.orange,
		[colours.lime] = colours.green,
		[colours.pink] = colours.magenta,
		[colours.grey] = colours.black,
		[colours.lightGrey] = colours.grey,
		[colours.cyan] = colours.blue,
		[colours.purple] = colours.grey,
		[colours.blue] = colours.grey,
		[colours.brown] = colours.grey,
		[colours.green] = colours.grey,
		[colours.red] = colours.brown,
		[colours.black] = colours.black,
		[colours.transparent] = colours.transparent,
	},

	Lighter = {
		[colours.white] = colours.lightGrey,
		[colours.orange] = colours.yellow,
		[colours.magenta] = colours.pink,
		[colours.lightBlue] = colours.cyan,
		[colours.yellow] = colours.orange,
		[colours.lime] = colours.green,
		[colours.pink] = colours.magenta,
		[colours.grey] = colours.lightGrey,
		[colours.lightGrey] = colours.grey,
		[colours.cyan] = colours.lightBlue,
		[colours.purple] = colours.magenta,
		[colours.blue] = colours.lightBlue,
		[colours.brown] = colours.red,
		[colours.green] = colours.lime,
		[colours.red] = colours.orange,
		[colours.black] = colours.grey,
		[colours.transparent] = colours.transparent,
	},

	Highlight = {
		[colours.white] = colours.lightGrey,
		[colours.orange] = colours.yellow,
		[colours.magenta] = colours.pink,
		[colours.lightBlue] = colours.cyan,
		[colours.yellow] = colours.orange,
		[colours.lime] = colours.green,
		[colours.pink] = colours.magenta,
		[colours.grey] = colours.lightGrey,
		[colours.lightGrey] = colours.grey,
		[colours.cyan] = colours.lightBlue,
		[colours.purple] = colours.magenta,
		[colours.blue] = colours.lightBlue,
		[colours.brown] = colours.red,
		[colours.green] = colours.lime,
		[colours.red] = colours.orange,
		[colours.black] = colours.grey,
		[colours.transparent] = colours.transparent,
	},

	Invert = {
		[colours.white] = colours.black,
		[colours.orange] = colours.blue,
		[colours.magenta] = colours.green,
		[colours.lightBlue] = colours.brown,
		[colours.yellow] = colours.blue,
		[colours.lime] = colours.purple,
		[colours.pink] = colours.green,
		[colours.grey] = colours.lightGrey,
		[colours.lightGrey] = colours.grey,
		[colours.cyan] = colours.red,
		[colours.purple] = colours.green,
		[colours.blue] = colours.yellow,
		[colours.brown] = colours.lightBlue,
		[colours.green] = colours.purple,
		[colours.red] = colours.cyan,
		[colours.black] = colours.white,
		[colours.transparent] = colours.transparent,
	},
}

function FilterColour(colour, filter)
	if filter[colour] then
		return filter[colour]
	else
		return colour
	end
end

DrawCharacters = function (x, y, characters, textColour, bgColour)
	WriteStringToBuffer(x, y, tostring(characters), textColour, bgColour)
end

DrawBlankArea = function (x, y, w, h, colour)
	if colour ~= colours.transparent then
		DrawArea(x, y, w, h, " ", 1, colour)
	end
end

DrawArea = function (x, y, w, h, character, textColour, bgColour)
	--width must be greater than 1, otherwise we get problems
	if w < 0 then
		w = w * -1
	elseif w == 0 then
		w = 1
	end

	for ix = 1, w do
		local currX = x + ix - 1
		for iy = 1, h do
			local currY = y + iy - 1
			WriteToBuffer(currX, currY, character, textColour, bgColour)
		end
	end
end

DrawImage = function(_x,_y,tImage, w, h)
	if tImage then
		for y = 1, h do
			if not tImage[y] then
				break
			end
			for x = 1, w do
				if not tImage[y][x] then
					break
				end
				local bgColour = tImage[y][x]
	            local textColour = tImage.textcol[y][x] or colours.white
	            local char = tImage.text[y][x]
	            WriteToBuffer(x+_x-1, y+_y-1, char, textColour, bgColour)
			end
		end
	elseif w and h then
		DrawBlankArea(_x, _y, w, h, colours.lightGrey)
	end
end

--using .nft
LoadImage = function(path, global)
	local image = {
		text = {},
		textcol = {}
	}
	if fs.exists(path) then
		local _io = io
		if OneOS and global then
			_io = OneOS.IO
		end
        local file = _io.open(path, "r")
        if not file then
        	error('Error Occured. _io:'..tostring(_io)..' OneOS: '..tostring(OneOS)..' OneOS.IO'..tostring(OneOS.IO)..' io: '..tostring(io))
        end
        local sLine = file:read()
        local num = 1
        while sLine do  
            table.insert(image, num, {})
            table.insert(image.text, num, {})
            table.insert(image.textcol, num, {})
                                        
            --As we're no longer 1-1, we keep track of what index to write to
            local writeIndex = 1
            --Tells us if we've hit a 30 or 31 (BG and FG respectively)- next char specifies the curr colour
            local bgNext, fgNext = false, false
            --The current background and foreground colours
            local currBG, currFG = nil,nil
            for i=1,#sLine do
                    local nextChar = string.sub(sLine, i, i)
                    if nextChar:byte() == 30 then
                            bgNext = true
                    elseif nextChar:byte() == 31 then
                            fgNext = true
                    elseif bgNext then
                            currBG = GetColour(nextChar)
		                    if currBG == nil then
		                    	currBG = colours.transparent
		                    end
                            bgNext = false
                    elseif fgNext then
                            currFG = GetColour(nextChar)
		                    if currFG == nil or currFG == colours.transparent then
		                    	currFG = colours.white
		                    end
                            fgNext = false
                    else
                            if nextChar ~= " " and currFG == nil then
                                    currFG = colours.white
                            end
                            image[num][writeIndex] = currBG
                            image.textcol[num][writeIndex] = currFG
                            image.text[num][writeIndex] = nextChar
                            writeIndex = writeIndex + 1
                    end
            end
            num = num+1
            sLine = file:read()
        end
        file:close()
    else
    	return nil
	end
 	return image
end

DrawCharactersCenter = function(x, y, w, h, characters, textColour,bgColour)
	w = w or Screen.Width
	h = h or Screen.Height
	x = x or 0
	y = y or 0
	x = math.floor((w - #characters) / 2) + x
	y = math.floor(h / 2) + y

	DrawCharacters(x, y, characters, textColour, bgColour)
end

GetColour = function(hex)
	if hex == ' ' then
		return colours.transparent
	end
    local value = tonumber(hex, 16)
    if not value then return nil end
    value = math.pow(2,value)
    return value
end

Clear = function (_colour)
	_colour = _colour or colours.black
	DrawBlankArea(1, 1, Screen.Width, Screen.Height, _colour)
end

Buffer = {}
BackBuffer = {}

local buffer = Buffer
local backBuffer = BackBuffer

TryRestore = false


--TODO: make this quicker
-- maybe sort the pixels in order of colour so it doesn't have to set the colour each time
DrawBuffer = function()
	if TryRestore and Restore then
		Restore()
	end

	-- If the program is within OneOS pass our buffer straight to the OS to draw rather than fidling around with the term API

	if OneOS and OneOS.Buffer then
		buffer = OneOS.Buffer
	else
		for y,row in pairs(buffer) do
			for x,pixel in pairs(row) do
				local shouldDraw = true
				local hasBackBuffer = true
				if BackBuffer[y] == nil or BackBuffer[y][x] == nil or #BackBuffer[y][x] ~= 3 then
					hasBackBuffer = false
				end
				if hasBackBuffer and BackBuffer[y][x][1] == buffer[y][x][1] and BackBuffer[y][x][2] == buffer[y][x][2] and BackBuffer[y][x][3] == buffer[y][x][3] then
					shouldDraw = false
				end
				if shouldDraw then
					term.setBackgroundColour(pixel[3])
					term.setTextColour(pixel[2])
					term.setCursorPos(x, y)
					term.write(pixel[1])
				end
			end
		end
	end
	BackBuffer = buffer
	buffer = {}
end

ClearBuffer = function()
	buffer = {}
end

WriteStringToBuffer = function (x, y, characters, textColour,bgColour)
	for i = 1, #characters do
		local character = characters:sub(i,i)
		WriteToBuffer(x + i - 1, y, character, textColour, bgColour)
	end
end

WriteToBuffer = function(x, y, character, textColour,bgColour, cached)
	if not cached and not WithinContraint(x, y) then
		return
	end
	x = round(x)
	y = round(y)

	if textColour == colours.transparent then
		character = ' '
	end

	if bgColour == colours.transparent then
		buffer[y] = buffer[y] or {}
		buffer[y][x] = buffer[y][x] or {"", colours.white, colours.black}
		buffer[y][x][1] = character
		buffer[y][x][2] = textColour
	else
		buffer[y] = buffer[y] or {}
		buffer[y][x] = {character, textColour, bgColour}
	end

	if copyBuffer then
		copyBuffer[y] = copyBuffer[y] or {}
		copyBuffer[y][x] = {character, textColour, bgColour}		
	end
end

DrawCachedBuffer = function(buffer)
	for y, row in pairs(buffer) do
		for x, pixel in pairs(row) do
			WriteToBuffer(x, y, pixel[1], pixel[2], pixel[3], true)
		end
	end
end

StartCopyBuffer = function()
	copyBuffer = {}
end

EndCopyBuffer = function()
	local tmpCopy = copyBuffer
	copyBuffer = nil
	return tmpCopy
end
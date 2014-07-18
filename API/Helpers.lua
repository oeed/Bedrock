LongestString = function(input, key, isKey)
	local length = 0
	if isKey then
		for k, v in pairs(input) do
			local titleLength = string.len(k)
			if titleLength > length then
				length = titleLength
			end
		end
	else
		for i = 1, #input do
			local value = input[i]
			if key then
				if value[key] then
					value = value[key]
				else
					value = ''
				end
			end
			local titleLength = string.len(value)
			if titleLength > length then
				length = titleLength
			end
		end
	end
	return length
end

Split = function(str,sep)
    sep=sep or'/'
    return str:match("(.*"..sep..")")
end

Extension = function(path, addDot)
	if not path then
		return nil
	elseif not string.find(fs.getName(path), '%.') then
		if not addDot then
			return fs.getName(path)
		else
			return ''
		end
	else
		local _path = path
		if path:sub(#path) == '/' then
			_path = path:sub(1,#path-1)
		end
		local extension = _path:gmatch('%.[0-9a-z]+$')()
		if extension then
			extension = extension:sub(2)
		else
			--extension = nil
			return ''
		end
		if addDot then
			extension = '.'..extension
		end
		return extension:lower()
	end
end

RemoveExtension = function(path)
--local name = string.match(fs.getName(path), '(%a+)%.?.-')
	if path:sub(1,1) == '.' then
		return path
	end
	local extension = Helpers.Extension(path)
	if extension == path then
		return fs.getName(path)
	end
	return string.gsub(path, extension, ''):sub(1, -2)
end

RemoveFileName = function(path)
	if string.sub(path, -1) == '/' then
		path = string.sub(path, 1, -2)
	end
	local v = string.match(path, "(.-)([^\\/]-%.?([^%.\\/]*))$")
	if type(v) == 'string' then
		return v
	end
	return v[1]
end

TruncateString = function(sString, maxLength)
	if #sString > maxLength then
		sString = sString:sub(1,maxLength-3)
		if sString:sub(-1) == ' ' then
			sString = sString:sub(1,maxLength-4)
		end
		sString = sString  .. '...'
	end
	return sString
end

TruncateStringStart = function(sString, maxLength)
	local len = #sString
	if #sString > maxLength then
		sString = sString:sub(len - maxLength, len - 3)
		if sString:sub(-1) == ' ' then
			sString = sString:sub(len - maxLength, len - 4)
		end
		sString = '...' .. sString
	end
	return sString
end

WrapText = function(text, maxWidth)
	local lines = {''}
    for word, space in text:gmatch('(%S+)(%s*)') do
            local temp = lines[#lines] .. word .. space:gsub('\n','')
            if #temp > maxWidth then
                    table.insert(lines, '')
            end
            if space:find('\n') then
                    lines[#lines] = lines[#lines] .. word
                    
                    space = space:gsub('\n', function()
                            table.insert(lines, '')
                            return ''
                    end)
            else
                    lines[#lines] = lines[#lines] .. word .. space
            end
    end
	return lines
end

TidyPath = function(path)
	path = '/'..path
	if fs.exists(path) and fs.isDir(path) then
		path = path .. '/'
	end

	path, n = path:gsub("//", "/")
	while n > 0 do
		path, n = path:gsub("//", "/")
	end
	return path
end

Capitalise = function(str)
	return str:sub(1, 1):upper() .. str:sub(2, -1)
end

Round = function(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
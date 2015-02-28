Channel = 42000
Callbacks = {}
CallbackTimeouts = {}
MessageTimeout = 0.5
MessageTypeHandlers = {}

local getNames = peripheral.getNames or function()
    local tResults = {}
    for n,sSide in ipairs( rs.getSides() ) do
            if peripheral.isPresent( sSide ) then
                    table.insert( tResults, sSide )
                    local isWireless = false
                    if pcall(function()isWireless = peripheral.call(sSide, 'isWireless') end) then
                            isWireless = true
                    end     
                    if peripheral.getType( sSide ) == "modem" and not isWireless then
                            local tRemote = peripheral.call( sSide, "getNamesRemote" )
                            for n,sName in ipairs( tRemote ) do
                                    table.insert( tResults, sName )
                            end
                    end
            end
    end
    return tResults
end

GetModems = function(self, callback)
    local ok = false
    for i, name in ipairs(getNames()) do
            ok = true
            if callback then
                    local p = peripheral.wrap(name)
                    callback(p, name)
            end
    end
    return ok
end

Initialise = function(self, bedrock)
    local new = {}
    setmetatable(new, {__index = self})
    new.Bedrock = bedrock
    new.Bedrock:RegisterEvent('modem_message', function(_, event, name, channel, replyChannel, message, distance)
            new:OnMessage(event, name, channel, replyChannel, message, distance)
    end)
    if new:GetModems(function(modem, name)
                    modem.open(new.Channel)
            end)
    then
            return new
    end
    return false
end

RegisterMessageType = function(self, msgType, callback)
    self.MessageTypeHandlers[msgType] = callback
end

OnMessage = function(self, event, name, channel, replyChannel, message, distance)
    if channel == self.Channel and type(message) == 'table' and message.msgType and message.thread and message.id ~= os.getComputerID() then
            if self.Callbacks[message.thread] then
                    local response, callback = self.Callbacks[message.thread](message.content, message, distance)
                    if response ~= nil then
                            self:Reply(response, message, callback)
                    end
            elseif self.MessageTypeHandlers[message.msgType] then
                    local response = self.MessageTypeHandlers[message.msgType](message, message.msgType, message.content, distance)
                    if response ~= nil then
                            self:Reply(response, message)
                    end
            else
            end
            return true
    else
            return false
    end
end

Reply = function(self, content, message, callback)
    self:SendMessage(message.msgType, content, callback, message.thread)
end

SendMessage = function(self, msgType, content, callback, thread, multiple)
    thread = thread or tostring(math.random())
    if self:GetModems(function(modem, name)
                    modem.transmit(self.Channel, self.Channel, {msgType = msgType, content = content, thread = thread, id = os.getComputerID()})
            end)
    then
            if callback then
                    self.Callbacks[thread] = function(...)
                            if not multiple then
                                    self.Callbacks[thread] = nil
                                    self.CallbackTimeouts[thread] = nil
                            end
                            return callback(...), callback
                    end
                    self.CallbackTimeouts[thread] = self.Bedrock:StartTimer(function(_, timer)
                            if timer == self.CallbackTimeouts[thread] then
                                    callback(false)
                            end
                    end, self.MessageTimeout)
            end
            return true
    end
    return false
end
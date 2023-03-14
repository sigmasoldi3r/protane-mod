-- Network abstractions
-- It includes p2p abstractions like the gossip protocol.
local lib = {}

lib.modem = peripheral.find('modem')

-- Returns first side
function lib.findModem()
    for _, side in pairs(peripheral.getNames()) do
        if peripheral.getType(side) == 'modem' then
            return side
        end
    end
end

-- Starts networking
function lib.open()
    lib.openSide = lib.findModem()
    if lib.openSide == nil then
        return false
    end
    rednet.open(lib.openSide)
    return true
end

-- Ends networking
function lib.close()
    rednet.close(lib.openSide)
    lib.openSide = nil
end

---Broadcasts a message
---@param message any
function lib.cast(message)
    rednet.broadcast(textutils.serialize(message), lib.protocol)
end

--- # Network Lookup
--- Performs a lookup of hosts that are using the same protocol.
--- Name parameter is **optional**.
---
--- Example:
--- ```lua
--- net.protocol = "walker"
--- local hosts = net.lookup()
--- for k, v in pairs(hosts) do print(k, "=", v) end
--- ```
---@param name string | nil
function lib.lookup(name)
    return {rednet.lookup(lib.protocol, name)}
end

function _rname()
    return tostring {}:sub(8)
end

--- Registers the host with the given name, if any, or a generated id
--- It is advised to use the default provided ID.
---@param name string|nil
---@returns string
function lib.host(name)
    local id = name or (_rname() .. _rname() .. _rname())
    rednet.host(lib.protocol, id)
    return id
end

---Awaits for the next message
function lib.listen(timeout)
    local id, raw, dst = rednet.receive(lib.protocol, timeout)
    if raw == nil then
        return nil
    end
    return textutils.unserialize(raw), id, dst
end

function lib.respond(to)
    return function(message)
        rednet.send(to, textutils.serialize(message), lib.protocol)
    end
end

function lib.respondRandom(message)
    local hosts = lib.lookup()
    if #hosts <= 0 then
        return false
    end
    local host = hosts[math.random(#hosts)]
    lib.respond(host)(message)
    return host
end

return lib

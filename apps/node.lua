-- Blocklike node
local net = require 'net'
local chain = require 'chain'

if not net.open() then
    error 'Could not bind modem. Aborting!'
end

local PROTOCOL = 'chainlink'
net.protocol = PROTOCOL

local CHAIN_FUNDS = 100000000000
local ROOT_ADDRESS = chain.seed(CHAIN_FUNDS)
local ID = net.host()

print('Registering machine as ' .. ID)
print('Starting node with protocol ' .. PROTOCOL)
print('Connecting to the network...')
net.cast({
    command = 'fetch'
})
local echo = net.listen(2)
if echo == nil then
    print('First node on the chain!')
else
    print('Fetching chain data...')
    chain.link = echo.payload
    chain.depth = echo.size
    print('Fetch of ' .. chain.depth .. ' transactions done.')
end
print('Connected to network')

local function stripCopy(object)
    if type(object) ~= 'object' then
        return object
    end
    local data = {}
    for k, v in pairs(object) do
        data[k] = v
    end
    data.previous = nil
    return data
end

while true do
    local data, from = net.listen()
    if data.command == 'fetch' then
        net.respond(from) {
            command = 'push',
            payload = chain.link,
            size = chain.depth
        }
    elseif data.command == 'client::new-address' then
        local result = chain.account(data.meta)
        print('MKADDR ' .. result)
        net.respond(from)(result)
    end
end

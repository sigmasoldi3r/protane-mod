-- Test script
local net = require 'net'

net.protocol = 'chainlink'
net.open()

local hosts = net.lookup()
if #hosts <= 0 then
    error 'No hosts available'
end

net.respondRandom {
    command = 'client::new-address'
}
local addr = net.listen(2)
print(textutils.serialize(addr))

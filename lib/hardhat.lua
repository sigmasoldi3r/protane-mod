local chain = require 'chain'

local CHAIN_FUNDS = 100000000000
local ROOT_ADDRESS = chain.seed(CHAIN_FUNDS)

local sm, code, err = chain.contract([[
  local foo = 'bar'
  local sc = {}
  function sc.ponder(args)
    return foo .. args.name
  end
  return sc
]])

local addr = chain.account()
chain.transfer(ROOT_ADDRESS, addr, 10000)

local bob = chain.account()
chain.transfer(addr, bob, 10)

local alice = chain.account()
chain.transfer(addr, alice, 10)

chain.transfer(alice, bob, 1)
chain.transfer(alice, addr, 5)
chain.transfer(bob, alice, 2)

print(addr .. ':addr = ', chain.balance(addr))
print(bob .. ':bob = ', chain.balance(bob))
print(alice .. ':alice = ', chain.balance(alice))

local call = chain.call(sm.addr, bob, 'ponder', {
    name = 'foo'
})
call.previous = nil
print('sm call -> ', textutils.serializeJSON(call))

local md5 = require 'md5'

---Blockchain library!
---Pure off-line, on-chain actions.
---Now you can store your data in linear storage!
local chain = {
    link = nil,
    depth = 0
}

---Generates the hash of the payload.
---@return string
function chain.hash(...)
    local payload = ''
    for _, part in pairs {...} do
        payload = payload .. textutils.serializeJSON(part)
    end
    return md5.sumhexa(payload)
end

---Add an entry to the blockchain
---@param object any
function chain.add(object)
    local out = {}
    for k, v in pairs(object) do
        out[k] = v
    end
    out.hash = chain.hash(object, (chain.link or {}).hash or '')
    out.previous = chain.link
    chain.link = out
    chain.depth = chain.depth + 1
    local copy = {}
    for k, v in pairs(out) do
        copy[k] = v
    end
    return copy
end

---Creates a new account
---@param meta string|nil
function chain.account(meta)
    local mov = chain.add {
        amount = 1,
        addr = chain.hash(chain.link, 'account-creation'),
        action = 'account',
        meta = meta or ''
    }
    return mov.addr, mov
end

---Adds a transfer movement
---@param from any
---@param to any
---@param amount any
---@param token any
---@param meta any
function chain.transfer(from, to, amount, token, meta)
    return chain.add {
        amount = amount,
        to = to,
        from = from,
        action = 'transfer',
        token = token or 'lnk',
        meta = meta or ''
    }
end

---Computes the address balance
---@param addr string
---@return number|nil
function chain.balance(addr)
    local bal = 0
    local top = chain.link
    while true do
        if top.previous == nil or (top.action == 'account' and top.addr == addr) then
            return bal
        elseif top.action == 'transfer' then
            if top.from == addr then
                bal = bal - top.amount
            elseif top.to == addr then
                bal = bal + top.amount
            end
        end
        top = top.previous
    end
end

-- Creates a smart contract
function chain.contract(code, meta)
    local f = loadstring(code)
    local ok, r = pcall(f)
    if not ok then
        return nil, 'badcode', r
    end
    return chain.add {
        addr = chain.account(),
        amount = 1,
        meta = meta or '',
        code = code,
        action = 'contract'
    }
end

---Finds transaction information by hash
---@param hash string
function chain.findByHash(hash)
    local top = chain.link
    while true do
        if top.previous == nil then
            return nil
        end
        if top.hash == hash then
            return top
        end
        top = top.previous
    end
end

--- Smart contract lookup
--- Returns a smart contract creation transaction, if present.
---@param target string
---@return transaction|nil
function chain.findContract(target)
    local top = chain.link
    while true do
        if top.previous == nil then
            return nil
        end
        if top.addr == target and top.action == 'contract' then
            return top
        end
        top = top.previous
    end
end

---Performs a call into the smart contract, if present.
---@param target string
---@param caller string
---@param method string
---@param arguments any
---@param meta string
function chain.call(target, caller, method, arguments, meta)
    local contract = chain.findContract(target)
    if contract == nil then
        return nil, 'nocontract'
    end
    local f = loadstring(contract.code)
    local ok, r = pcall(f)
    if not ok or (ok and r == nil) then
        return nil, 'badcode', r
    end
    if r[method] == nil then
        return nil, 'badmethod'
    end
    local ok, rr = pcall(r[method], arguments)
    if not ok then
        return nil, 'badcall', rr
    end
    return chain.add {
        action = 'call',
        result = textutils.serializeJSON(rr),
        target = target,
        caller = caller,
        method = method,
        arguments = arguments,
        meta = meta or ''
    }
end

---Generates the first block, run only once!
---@param funds number
---@return string, transaction
function chain.seed(funds)
    chain.ROOT_ADDRESS = chain.account()
    local tx = chain.transfer(nil, ROOT_ADDRESS, funds)
    return chain.ROOT_ADDRESS, tx
end

return chain

local JWT_HEADER = 'eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.'
local JWT_BODY_START_AT = #JWT_HEADER + 1
local JWT_SIGNATURE_LENGTH = 86
local JWT_MIN_LENGTH = JWT_BODY_START_AT + JWT_SIGNATURE_LENGTH
local JWT_EXPIRES_IN = 3600
local PK

local ngx = ngx
local time = ngx.time
local sub = string.sub
local tostring = tostring
local match = string.match
local from_b64 = ngx.decode_base64
local get_headers = ngx.req.get_headers

local from_json = require 'cjson.safe'.decode
local from_b64url = require 'ngx.base64'.decode_base64url
local verify = require 'luasodium'.crypto_sign_verify_detached


---@param token string?
---@return table?
---@return string?
local function parse_jwt(token)
    if not token or #token < JWT_MIN_LENGTH then
        return nil, 'No JWT!'
    end

    local message = sub(token, 1, #token - JWT_SIGNATURE_LENGTH - 1)
    local jwt, err = from_json(from_b64url(sub(message, JWT_BODY_START_AT)) or '')
    if err then
        return nil, err
    elseif type(jwt) ~= 'table' then
        return nil, 'Wrong JWT!'
    elseif (jwt.exp or 0) < time() then
        return nil, 'JWT expired'
    else
        jwt.message = message
    end

    jwt.signature, err = from_b64url(sub(token, -JWT_SIGNATURE_LENGTH))
    if err then
        return nil, err
    end

    return jwt
end


---@param extract_pk boolean?
---@param token string?
---@return table?
---@return string?
local function verify_jwt(extract_pk, token)
    local jwt, err = parse_jwt(token or match(tostring(get_headers()['Authorization'] or ''), '(%S+)', 8))
    if not jwt then
        return nil, err
    end
    if verify(jwt.signature, jwt.message, extract_pk and from_b64url(jwt.pk) or PK) then
        return jwt
    else
        return nil, 'Wrong signature!'
    end
end


---@param pk string
---@param exp string
---@return nil
local function init(pk, exp)
    local expire = tonumber(exp)
    if expire then
        JWT_EXPIRES_IN = math.floor(expire)
    end
    PK = sub(from_b64(pk:match'\n(.+)\n'), -32)
end


return {
    init = init,
    verify_jwt = verify_jwt,
}

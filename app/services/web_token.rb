class WebToken
    HMAC_SECRET = 'my$ecretK3y'
    AL_TYPE = 'HS256'

    def self.encode(user_id)
        payload = {user_id: user_id,exp:Time.now.to_i + 2.weeks}
        JWT.encode payload, HMAC_SECRET, AL_TYPE
       
    end 

    def self.decode(token)
        decode_token = JWT.decode token, HMAC_SECRET, true, {algorithm:AL_TYPE}
        decode_token[0]["user_id"]
        
    end
end
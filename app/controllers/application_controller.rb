class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token
    before_action :verify_jwt, except: [:oauth_signin]
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from JWT::ExpiredSignature, with: :fail_jwt_verify
    rescue_from JWT::VerificationError, with: :fail_jwt_verify

    def verify_jwt
        token,_options = token_and_options(request)
        user_id = WebToken.decode(token)
        @current_user = User.find_by_id(user_id)
    end 

    def fail_jwt_verify
        render json:{message:"Invalid jwt"}, status: :unauthorized
    end

    private
    def parameter_missing(e)
        render json: {errors: e.message}, status: 422
    end




end

class Api::V1::SessionsController < ApplicationController
skip_before_action :verify_jwt
before_action :set_user, only: [:create]
rescue_from ActiveRecord::RecordNotFound  ,with: :invalid_credential


    def create
        if @user.authenticate(params[:password])
            token = WebToken.encode(@user.id)
            render json: {token:token}, status: 200
        else
            invalid_credential
        end
        

    end 

    def oauth_signin
        user = User.find_by(provider: oauth_params[:provider],uid:oauth_params[:uid])       
        unless user 
            user = User.new(oauth_params) 
            unless user.save 
                render json: user.errors, status: 422
                return
            end
            project = Project.new(title:"Home",user_id:user.id,position:0)
            unless project.save 
                render json: project.errors, status: 422
                return
            end 
                
        end
        token = WebToken.encode(user.id)
        render json: {token:token}, status:200
        
    end 



    def set_user 
        @user = User.find_by(email: params[:email])
        raise ActiveRecord::RecordNotFound if !@user
        @user
    end
    

    def invalid_credential
        render json: {message:"Invalid credentail"}, status: :unauthorized
    end 

    def oauth_params
        params.require(:user).permit(:email,:uid,:provider)
    end

    

end

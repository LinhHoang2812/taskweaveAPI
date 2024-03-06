class Api::V1::RegistrationsController < ApplicationController
    before_action :check_user_exist, only:[:create]
    before_action :verify_jwt, except: [:create]

    def create
        user = User.new(user_params)
        if user.save
            token = WebToken.encode(user.id)
            project = Project.new(title:"Home",user_id:user.id,position:0)
            unless project.save 
                render json: project.errors, status: 422
                return
            end      
            render json: {token: token},  status: :created
        else
          render json: user.errors, status: 422
        end         

    end 

    private 
    def user_params
        params.require(:user).permit(:email,:password)
    end 

    def check_user_exist
        user = User.where(email:user_params[:email],provider: nil)[0]
        if user
            render json: {error:"Email already exists, please sign in."}, status: 400
        end

    end
end

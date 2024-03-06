class Api::V1::ProjectsController < ApplicationController
    before_action :set_project, only: [:show,:update,:destroy]
    before_action :set_position, only: [:create]
    

    def index
        # @projects = Project.includes(:sections).where(user_id:@current_user.id)
        @projects = Project.where(user_id:@current_user.id).order(:position)
        render json: @projects, status:200
    end

    def show    
        
        #render json: @project, include: :sections ,status: 200
        render json: @project,serializer: Api::V1::ProjectsSerializer  ,status: 200 

    end 

    def create
        project = Project.new(project_params)
        project.position = @position
        if project.save
            render json: project, status:200
        else
            render json: {errors: project.errors}, status:422
        end

    end

    def update
        if @project.update(project_params)
            render json: @project, status:200
        else
            render json: {errors: @project.errors},status:422
        end
    end 

    def update_projects_multiple
        params[:projects].map do |project|
            Project.find(project[:id]).update(project.permit(:id,:title,:position))
        end
        render json:{message:"proccessed"},status:200
    end

    def destroy
        if @project.destroy
            projects_to_update = Project.where(user_id: @current_user.id).where("position > ?",@project.position)
            projects_to_update.map do |project|
                new_position = project[:position] - 1
                project.update(position:new_position)
            end

            head :no_content
        else
            render json: {errors: @project.errors},status:422
        end
        
    end

    private
    def set_project
        # @project = Project.includes([:sections,:tasks]).find(params.require(:id))
         @project = Project.find(params[:id])
        

    end

    def project_params
        params.require(:project).permit(:title,:project_id).tap {|p| p[:user_id]= @current_user.id}
    end

    def set_position
       @position = Project.where(user_id: @current_user.id).maximum(:position).to_i + 1
       
        
    end


   
end

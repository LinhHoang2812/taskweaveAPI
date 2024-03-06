class Api::V1::SectionsController < ApplicationController
     before_action :set_section, only: [:show,:update,:destroy]
     before_action :set_position, only: [:create]

    def index
        @sections = Section.where(project_id: params[:project_id])
        render json: @sections,  status:200
    end

    def show
        
        render json: @section,serializer: Api::V1::SectionsSerializer , status:200

       
    end

    def create
         section = Section.new(section_params)
         section.position = @position
        if section.save
            render json: section, status:200
        else
            render json: {errors: section.errors}, status: 422
        end
    end

    def update
        if @section.update(section_params)
             render json: @section, status:200
        else
            render json: {errors: @section.errors}, status: 422
        end
    end

    def update_sections_multiple
        params[:sections].map do |section|
            Section.find(section[:id]).update(section.permit(:id,:title,:position))
        end
        render json:{message:"proccessed"},status:200
    end

    def destroy
        if @section.destroy
            sections_to_update = Section.where(project_id:params[:project_id]).where("position > ?",@section.position)
            sections_to_update.map do |section|
                new_position = section[:position] - 1
                section.update(position:new_position)
            end

            head :no_content
        else
            render json: {errors: @section.errors}, status: 422
        end
    end

    private
    def set_section
        @section = Section.find(params[:id])
    end

    def section_params
        params.require(:section).permit(:title,:project_id).tap{ |p| p[:project_id]=params[:project_id] }
    end

    def set_position
        max_position = Section.where(project_id: params[:project_id]).maximum(:position) 
        
        if max_position == nil
        @position = 0
        else 
        @position = max_position.to_i + 1
        end
       
        
    end

end

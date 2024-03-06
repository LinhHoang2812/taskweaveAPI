require "date"
class Api::V1::TasksController < ApplicationController
    before_action :set_task, only: [:show,:update,:destroy]
    before_action :set_project_task, only: [:get_project_task,:update_project_task,:delete_project_task]
    before_action :week_days, only: [:get_weekly_tasks]
    before_action :set_day_task, only: [:show_day_task,:update_day_task,:delete_day_task]
    before_action :set_position, only: [:create_day_task]
    before_action :set_task_position, only: [:create]
    
    def index
        @tasks = Task.where(taskable_id: params[:section_id],taskable_type: "Section")
        render json: @tasks, status:200
    end

    def show
        render json: @task,serializer: Api::V1::TasksSerializer, status:200
    end

    def create
        task = Task.new(task_params)
        task.position = @task_position
        if task.save
            render json: task, status:200
        else 
            render json: {errors: task.errors},status:422
        end
    end 
    
    def update
        if @task.update(task_params)
            render json: @task,status:200
        else
            render json: {errors: @task.errors},status:422
        end
    end 

    def destroy

        if @task.destroy
            tasks_to_update = Task.where(user_id:@current_user.id,taskable_id: params[:section_id]).where("position > ?",@task.position)
            tasks_to_update.map do |task|
                new_position = task[:position] - 1
                task.update(position:new_position)

            end
            
            head :no_content
        else
            render json: {errors: @task.errors},status:422
        end
    end 

    # tasks belongs to a project not section

    # def get_project_tasks
    #     @project_tasks = Task.where(taskable_id: params[:project_id],taskable_type:"Project")
    #     render json: @project_tasks, each_serializer: Api::V1::TasksSerializer, status:200
    # end

    # def get_project_task
    #     render json: @project_task,serializer: Api::V1::TasksSerializer, status:200
    # end

    # def create_project_task
    #     task = Task.new(task_project_params)
    #     if task.save
    #         render json: task,status:200
    #     else
    #         render json: {errors: task.errors},status:422
    #     end
    # end

    # def update_project_task
    #      if @project_task.update(task_project_params)
    #         render json: @project_task,status:200
    #     else
    #         render json: {errors: @project_task.errors},status:422
    #     end
    # end 

    # def delete_project_task
    #      if @project_task.destroy
    #         head :no_content
    #     else
    #         render json: {errors: @project_task.errors},status:422
    #     end
    # end 


    # standalone daily task
    def get_weekly_tasks
        @weekly_tasks = @week_days.map do |day| 
            tasks = Task.where(user_id: @current_user.id, due_date: day["date"],taskable_id: nil,taskable_type: nil).order(:position)
            day[:tasks] = tasks
            day
        end       
        render json: @weekly_tasks, status:200     
    end



    def create_day_task
        day_task = Task.new(day_task_params)
        day_task.validate_due_date = true
        day_task.position = @position
        
        if day_task.save
            render json: day_task, status:200
        else
            render json: {errors: day_task.errors},status:422
        end
    end 

    def show_day_task
        
        render json: @day_task, serializer: Api::V1::TasksSerializer ,status:200
    end

    def update_day_task
        if @day_task.update(day_task_params)
            render json: @day_task, status:200
        else
            render json:{errors: @day_task.errors},status:422
        end
    end

    def update_day_tasks_multiple
        
        # day_tasks_multiple[:task].map do |task|
        #     Task.find(task[:id]).update(task)
        # end
        params[:tasks].map do |task|
             Task.find(task["id"]).update(task.permit(:id,:position,:due_date,:title,:des,:taskable_id))
        end

        render json:{message:"processed"}, status:200

    end

    def delete_day_task
        
        if @day_task.destroy
            tasks_to_update = Task.where(user_id:@current_user.id,due_date:@day_task.due_date,taskable_id: nil,taskable_type: nil).where("position > ?",@day_task.position)
            tasks_to_update.map do |task|
                new_position = task[:position] - 1
                task.update(position:new_position)

            end
            

            head :no_content
            # render json: my_tasks,status:200
        else
            render json:{errors: @day_task.errors},status:422
        end

    end

    

    def get_today_tasks    
        today_tasks = Task.where(user_id: @current_user.id,due_date: Date.today)
        render json: today_tasks,status:200
    end


    private 
    def set_task
        @task = Task.find(params[:id])

    end 

    def set_project_task
        @project_task = Task.find(params[:id])
    end

    def set_day_task
        @day_task = Task.find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title,:des,:due_date,:taskable_id,:taskable_type,:user_id).tap do |p| 
            p[:taskable_id]= params[:section_id]
            p[:taskable_type] = "Section"
            p[:user_id] = @current_user.id
        end
    
    end 

    def update_after_delete
        my_tasks = Task.where(user_id:@current_user.id,due_date:"2024-02-25",taskable_id: nil,taskable_type: nil).where("position > ?",@day_task.position)
        puts my_tasks
    end

    def task_project_params
        params.require(:task).permit(:title,:des,:taskable_id,:taskable_type,:user_id).tap do |p| 
            p[:taskable_id]= params[:project_id]
            p[:taskable_type] = "Project"
            p[:user_id] = @current_user.id
        end
    end

    def day_task_params
        params.require(:task).permit(:title,:due_date,:user_id,:des).tap do |p|
            p[:user_id]=@current_user.id
            
        end
    end

  
        
    

    def week_days
        @days_of_weeks = ["Mon","Tue","Wed","Thur","Fri","Sat","Sun"]
        #find the start monday of the week
        #2024-02-23
        selected_day = Date.parse(params[:day])
       
        
        start_of_the_week = selected_day - (selected_day.wday - 1) % 7
        
        @week_days = (0..6).map do |n| 
            day =  @days_of_weeks[n]
            {"day_of_week"=> day,"date"=> start_of_the_week + n}
        end


    end

    def set_position
        max_position = Task.where(user_id: @current_user.id, due_date: params["task"]["due_date"],taskable_id: nil,taskable_type: nil).maximum(:position) 
        
        if max_position == nil
        @position = 0
        else 
        @position = max_position.to_i + 1
        end
       
        
    end


    def set_task_position
        max_position = Task.where(user_id: @current_user.id,taskable_id: params[:section_id],taskable_type: "Section").maximum(:position) 
        
        if max_position == nil
        @task_position = 0
        else 
        @task_position = max_position.to_i + 1
        end
       
        
    end





end

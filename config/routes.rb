Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create]
      post "signin", to: "sessions#create"
      post "oauth_signin", to:"sessions#oauth_signin"

      resources :projects do
        post "create_project_task", to:"tasks#create_project_task"
        get "get_project_tasks", to: "tasks#get_project_tasks"
        get "get_project_tasks/:id", to: "tasks#get_project_task"
        put "get_project_tasks/:id", to: "tasks#update_project_task"
        delete "get_project_tasks/:id", to: "tasks#delete_project_task"

        resources :sections do
          resources :tasks
        end
      end

      post "day_tasks",to: "tasks#create_day_task"
      get "day_tasks/:id",to: "tasks#show_day_task"
      put "day_tasks/:id",to:"tasks#update_day_task"
      put "update_day_tasks_multiple", to:"tasks#update_day_tasks_multiple"
      delete "day_tasks/:id",to: "tasks#delete_day_task"
      get "weekly_tasks", to: "tasks#get_weekly_tasks"
      get "today_tasks", to: "tasks#get_today_tasks"
      get "daily_tasks", to: "tasks#get_daily_tasks"

      put "update_projects_multiple", to: "projects#update_projects_multiple"
      put "update_sections_multiple", to: "sections#update_sections_multiple"
      
    end

  end
  
end

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy, :change]
 
  respond_to :html

  def index
    @to_do = current_user.tasks.where(state: "to_do")
	@doing = current_user.tasks.where(state: "doing")
	@done = current_user.tasks.where(state: "done")
    respond_with(@tasks)
  end

  def show
		redirect_to tasks_path
  end
  

  def new
    @task = Task.new
    respond_with(@task)
  end

  def edit
	unless @task.user == current_user
		redirect_to tasks_path
	end
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.save
	redirect_to tasks_path
  end

  def update
    @task.update(task_params)
	redirect_to tasks_path
  end

  def destroy
    @task.destroy
    respond_with(@task)
  end
  
  def change
	@task.update_attributes(state: params[:state])
	redirect_to tasks_path
  end
  
  private
    def set_task
		unless Task.exists?(params[:id])
			redirect_to tasks_path
		else
			@task = Task.find(params[:id])
		end
	end
	
    def task_params
      params.require(:task).permit(:content,:state)
    end
end

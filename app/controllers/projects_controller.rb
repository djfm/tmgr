class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.build(project_params.reverse_update :project_status => ProjectStatus.find_by_key('default'))

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_path(@project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to edit_project_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def available_statuses

      # only admin or author can change status of project
      if current_user.id != @project.user.id and !current_user.admin
        return nil
      end

      current = @project.project_status.try(:key) || 'default'

      keys = if current == 'default'
        ['default', 'locked']
      elsif current == 'locked'
        ['default', 'locked', 'launched']
      elsif current_user.admin
        ['default', 'locked', 'launched', 'completed']
      else
        []
      end
        
      return nil if keys.empty?

      keys.map do |key|
        status = ProjectStatus.find_by_key key
        [status.name, status.id]
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
      @available_statuses = available_statuses
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :deadline, :comments, :project_status_id)
    end

    def check_access
      if current_user.id != @project.user.id and !current_user.admin
        case @project.project_status.key
        when 'locked'
          redirect_to projects_url, :alert => 'Project is locked, only its owner or an admin can change it!'
        when 'launched'
          redirect_to projects_url, :alert => 'Project is already launched, too late.'
        when 'completed'
          redirect_to projects_url, :alert => 'Project is already completed!'
        end
      end
    end
end

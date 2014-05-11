class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
  end

  # GET /resources/new
  def new
    @resource = Resource.new
    if project_id = params[:project_id]
      @resource.project = Project.find(project_id)
    end
  end

  # GET /resources/1/edit
  def edit
  end

  def handle_extra_data
    if params['messages']
      @resource.raw_messages = @messages = params['messages'].sort.map do |k,v| v end
    end
    if params['text_file']
      @resource.raw_file = params['text_file']
    end
    @resource.raw_languages = params[:languages]
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(resource_params)

    handle_extra_data

    respond_to do |format|
      if @resource.save
        format.html { redirect_to edit_project_path(@resource.project), notice: 'Resource was successfully created.' }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    handle_extra_data

    # don't let people add stuff to a locked project
    if (new_project_id = resource_params[:project_id]) and new_project_id != @resource.project.id
      return unless check_access_for Project.find(new_project_id)
    end

    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to edit_project_path(@resource.project), notice: 'Resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to edit_project_path(@resource.project), notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /reassign
  def reassign
    @resource = Resource.find(params[:resource_id])
    if @resource
      @resource.assignment_for_language(params[:language_id]).try :destroy
      if params[:language_id].to_i >= 0
        success = !!@resource.assignments.create(params.permit(:resource_id, :language_id, :translator_id))
      else
        success = true
      end
      render :json => {success: success} 
    else
      render :json => {success: false}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
      @messages = @resource.messages
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      res = params.require(:resource).permit(:title, :resource_type, :project_id, :comments)
      res[:resource_type] = ResourceType.find_by_key(params[:resource][:resource_type])
      return res
    end

    def check_access_for project
      if current_user.id != project.user.id and !current_user.admin
        case project.project_status.key
        when 'locked'
          redirect_to projects_url, :alert => 'Target project is locked, only its owner or an admin can change it!'
          return false
        when 'launched'
          redirect_to projects_url, :alert => 'Target project is already launched, too late.'
          return false
        when 'sent'
          redirect_to projects_url, :alert => 'Target project was already sent to translators, too late.'
          return false
        when 'completed'
          redirect_to projects_url, :alert => 'Target project is already completed!'
          return false
        end
      elsif current_user.id == project.user.id and !current_user.admin
        unless ['default', 'locked'].include? project.project_status.key
          redirect_to projects_url, :alert => 'Project cannot be edited because it was already launched.'
        end
      end
      return true
    end

    def check_access
      check_access_for @resource.project
    end
end

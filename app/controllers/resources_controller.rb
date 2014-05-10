class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

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
      @resource.raw_file = params['text_file']
    end
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(resource_params)

    handle_extra_data

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
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

    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
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
      format.html { redirect_to resources_url, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
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
      res = params.require(:resource).permit(:title, :resource_type, :project_id)
      res[:resource_type] = ResourceType.find_by_key(params[:resource][:resource_type])
      res
    end
end

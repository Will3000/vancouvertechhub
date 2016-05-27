class OrganizationsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :filter]
  before_action :find_organization, only: [:show, :edit, :update, :destroy]

  ORGANIZATIONS_PER_PAGE = 18

  def new
    if current_user.organization.present?
      redirect_to organization_path(current_user.organization_id), alert: "You can only have one organization."
    end
    @organization = Organization.new
  end

  def show
    @claimed = @organization.claim_requests.find_by_status(true)
    hosting_event

    respond_to do |format|
      format.html { render }
      format.json { render json: @organization.to_json }
    end
  end

  def index
    if current_user && current_user.admin?
      @organizations = Organization.page(params[:page]).per(ORGANIZATIONS_PER_PAGE)
    else
      @organizations = Organization.published.page(params[:page]).per(ORGANIZATIONS_PER_PAGE)
    end
  end

  def edit
    @organization = Organization.find params[:id]
    if current_user.organization != @organization
      redirect_to organization_path(current_user.organization_id), alert: "You cannot edit other people's organizations."
    end
  end

  def filter
    organization_ids = params[:data_value]
    @organizations = Organization.where("id in (?)", organization_ids)
    respond_to do |format|
      format.js { render :filter_success }
    end
  end

  def update
    if @organization.update organization_params
      redirect_to organization_path(@organization), notice: "Organization Updated!"
    else
      render :edit
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: "organization: #{@organization.name} deleted!"
  end

  def create
    if current_user.organization_id.present?
      redirect_to organization_path(current_user.organization_id), alert: "You can only have one organization."
    end
    @organization       = Organization.new(organization_params)
    @organization.user  = current_user
    if @organization.save
      @organization.images[0].url # => '/url/to/file.png'
      @organization.images[0].current_path # => 'path/to/file.png'
      @organization.images[0].identifier # => 'file.png'
      redirect_to organization_path(@organization), notice: "Organization Created!"
    else
      flash[:alert] = "organization didn't save!"
      render :new
    end
  end

  private

  def find_organization
    if current_user && current_user.admin?
      @organization = Organization.find params[:id]
    else
      @organization = Organization.published.find params[:id]
    end
  end

  def organization_params
    params.require(:organization).permit([:name, :address, :overview, :employee_count, :tech_team_size, :website, :twitter, :logo, :published, :user_id, {technology_ids: []}, {images:[]} ])
  end

  def authorize_organization
    redirect_to root_path unless can? :cru, @organization
  end

  def hosting_event
    events = Event.all
    org_add = @organization.address.split(",")[0]
    @find = events.where("location ILIKE ?", "%#{org_add}%")
  end
end

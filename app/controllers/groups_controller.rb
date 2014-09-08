class GroupsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /groups/999
  def index
    if params[:password] == "999"
      render json: Group.all
    else
      render json: {error: 'wrong password'}
    end
  end

  # POST /groups.json
  def create
    @group = Group.new(group_params)
    if @group.save
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end


# Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:group_name)
  end

end

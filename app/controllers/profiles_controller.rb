class ProfilesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @profile = Profile.new(:display_name => params["profile"]["display_name"],
                           :description => params["profile"]["description"],
                           :email => params["profile"]["email"])
    if @profile.save
      render json: @profile, root: "data"
    else
      render text: "Bad request", status: 400
    end
  end

  def index
    if params.has_key?(:query)
      @profiles = Profile.search(params[:query])
    else
      @profiles = Profile.all
    end
    render json: @profiles, root: "data"
  end

  def show
    begin
      @profile = Profile.find(params[:id])
      render json: @profile, root: "data"
    rescue ActiveRecord::StatementInvalid
      render_404
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end

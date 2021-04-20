class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  protect_from_forgery with: :null_session

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json do
        render status: :forbidden, json: exception.message
      end
    end
  end


  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  protected
  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end

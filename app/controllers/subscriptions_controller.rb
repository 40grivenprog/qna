class SubscriptionsController < ApplicationController
  authorize_resource

  def create
    unless current_user.subscriptions.find_by(question_id: params[:question_id])
      @subscription = current_user.subscriptions.create(question_id: params[:question_id])
    end
  end

  def destroy
    subscription = Subscription.find(params[:id])
    @question = subscription.question
    subscription.destroy
  end
end

module Voted
  extend ActiveSupport::Concern

  def vote_for
    record.vote_for_by(current_user)
    votes_result_response
  end

  def vote_against
    record.vote_against_by(current_user)
    votes_result_response
  end

  def cancel_vote
    record.cancel_vote_by(current_user)
    votes_result_response
  end

  private

  def votes_result_response
    respond_to { |format| format.json { render json: {record_id: record.id, vote_result: record.calculate_score}} }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def record
    model_klass.find(params[:id])
  end
end

class SearchController < ApplicationController
  def search
    @service = SearchService.new(search_body)
    @result = @service.call
  end

  private
  def search_body
    params.permit(:body, :type)
  end
end

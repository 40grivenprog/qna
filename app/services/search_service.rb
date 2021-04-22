class SearchService
  TYPES = ["All", "Question", "Comment", "Answer", "User"]

  def initialize(params)
    @type = params[:type]
    @body = params[:body]
  end

  def call
    return [] if @body.empty?
    if @type == "All"
      ThinkingSphinx.search(@body)
    else
      Object.const_get(@type).search(@body)
    end
  end
end

class SearchController < ApplicationController

  include RailsNlp

  before_filter :filter_long_or_empty

  def index
    query = params[:q].strip

    @query = query

    @query_corrected = QueryExpansion.spell_check(query)

    query_expanded = QueryExpansion.expand(query)
    @query_expanded = query_expanded

    @results = Article.search(query_expanded).select(&:published?)


    respond_to do |format|
      format.json  { render @results }
      format.html
    end

  end

  private

  # Searchify can't handle requests longer than this (because of query
  # expansion + Tanker inefficencies.  >10 can result in >8000 byte request
  # strings)
  def filter_long_or_empty
    if params[:q].split.size > 10 || params[:q].blank?
      @query = params[:q]
      @results = []
      render and return
    end
  end
end
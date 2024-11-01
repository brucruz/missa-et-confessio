class AddressesController < ApplicationController
  def search
    results = fetch_geocoder_results.first(5)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "address_results",
          partial: "addresses/results",
          locals: { results: results }
        )
      }
    end
  end

  def search_churches
    query = params[:query]
    @results = if query.present? && query.length >= 3
      fetch_geocoder_results
        .select { |result| result.types.include?("church") }
        .first(5)
    else
      []
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def fetch_geocoder_results
    Geocoder.search(params[:query], lookup: :google_places_search)
  end
end

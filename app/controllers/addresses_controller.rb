class AddressesController < ApplicationController
  def search
    results = Geocoder.search(params[:query], lookup: :google_places_search).first(5)

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
end

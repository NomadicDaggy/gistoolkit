class CemeteriesController < ApplicationController

  def index
    @cemeteries = Cemetery.all

    respond_to do |format|
      format.json do
        feature_collection = Cemetery.to_feature_collection @cemeteries
        render json: RGeo::GeoJSON.encode(feature_collection)
      end

      format.html
    end
  end

  def map_data
    @cemeteries = Cemetery.choose($cem_id)
  end

  def show
#    @cemeteries = Cemetery.find(params[:id])
#    data = Cemetery.choose(params[:id])
#    render :json => data
  $cem_id = params[:id]
  end

  def list
    @cemeteries = Cemetery.paginate(page: params[:page])
  end

end

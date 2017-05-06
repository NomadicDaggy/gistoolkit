class CemeteriesController < ApplicationController

  def index
    @cemeteries = Cemetery.paginate(page: params[:page])
  end

  def cemetery_data
    @cemeteries = Cemetery.choose($cem_id)
  end

  def plots_data
    @plots = Plot.choose($cem_id)
  end

  def show
#    @cemeteries = Cemetery.find(params[:id])
#    data = Cemetery.choose(params[:id])
#    render :json => data
    $cem_id = params[:id]
  end

end

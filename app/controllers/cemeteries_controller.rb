class CemeteriesController < ApplicationController
  before_action :admin_user, only: [:index, :show]

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
    $cem_id = params[:id]
    @cemetery = Cemetery.find(params[:id])
  end

  private

    # Confirms an admin user.
    def admin_user
      unless admin?
        flash[:danger] = "Please log in."
        redirect_to(login_url)
      end
    end
end

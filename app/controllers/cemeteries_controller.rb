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

  def streets_data
    @streets = Street.choose($cem_id)
  end

  def sectors_data
    @sectors = Sector.choose($cem_id)
  end

  def points_data
    @points = Point.choose($cem_id)
  end

  def show
    $cem_id = params[:id]
    @cemetery = Cemetery.find(params[:id])
  end

  private

    # Confirms an admin user.
    def admin_user
      if logged_in? && !admin?
        flash[:danger] = "Cemeteries accessible only to admins. Contact site owner for access."
        redirect_to(contact_url)
      else
        unless admin?
          flash[:danger] = "Please log in."
          redirect_to(login_url)
        end
      end
    end
end

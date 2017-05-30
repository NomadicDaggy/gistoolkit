class CemeteriesController < ApplicationController
  # Execute action only if user admin
  before_action :admin_user, only: [:index, :show]

  # Uses Rails built-in pagination to gather all cemeteries for display
  def index
    @cemeteries = Cemetery.paginate(page: params[:page])
  end

  def show
    # Global var to store current cemetery id
    $cem_id = params[:id]
    @cemetery = Cemetery.find(params[:id])
  end

  # Selects raw map data from db
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

  private

    # Handles cemeteries access
    # If user not logged in -> login view
    # If user not admin     -> contact view
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

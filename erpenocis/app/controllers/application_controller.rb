class ApplicationController < ActionController::Base
  def set_dates_params
    @start_month = params[:sm]
    @start_year = params[:sy]
    @end_month = params[:em]
    @end_year = params[:ey]
    unless @start_month && @start_year && @end_month && @end_year
      @start_month = 1
      @start_year = Date.today().strftime("%Y")
      @end_month = 12
      @end_year = Date.today().strftime("%Y")
    end
  end
  def set_start_date(start_month ,start_year)
    Date.parse(start_year.to_s+'-'+start_month.to_s+'-01')
  end
  def set_end_date(end_month, end_year)
    Date.parse(end_year.to_s+'-'+end_month.to_s+'-01').next_month-1.day
  end
  
end

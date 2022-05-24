class ApplicationController < ActionController::Base
  def set_dates_params
    @start_month = params[:sm].to_i
    @start_year = params[:sy].to_i
    @end_month = params[:em].to_i
    @end_year = params[:ey].to_i
    unless @start_month!=0 && @start_year!=0 && @end_month!=0 && @end_year!=0
      @start_month = 1
      @start_year = Date.today().strftime("%Y").to_i
      @end_month = 12
      @end_year = Date.today().strftime("%Y").to_i
    end
    @months = (@end_year - @start_year) * 12 + @end_month - @start_month + 1
  end
  def set_start_date(start_month ,start_year)
    Date.parse(start_year.to_s+'-'+start_month.to_s+'-01')
  end
  def set_end_date(end_month, end_year)
    Date.parse(end_year.to_s+'-'+end_month.to_s+'-01').next_month-1.day
  end
  def set_table_head
    extra_years = 0
    @table_head = []
    @months.times do |month|
      @start_month + month - extra_years * 12 > 12 ? extra_years += 1 : extra_years
      @table_head[month] = ((@start_month + month) - (extra_years * 12)).to_s + " / " + (@start_year + extra_years).to_s
    end
  end
  def set_current_tab
    @current_tab = params[:current_tab]
  end
end

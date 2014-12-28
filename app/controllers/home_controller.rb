class HomeController < ApplicationController

  def index
  end

  def subway_sruf_api
  	result = {}
		begin
    	result[:success] = true
      result[:subway_surf_game] = Parser::AndroidDetail.new.parse_game
    rescue Exception => ex
      result[:success] = false
      result[:subway_surf_game] = []
    end
    respond_to do |format|
      format.json do
        render :json => result.to_json, :callback => params[:callback]
      end
    end
  end
   
end
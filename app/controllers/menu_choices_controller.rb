class MenuChoicesController < ApplicationController
  def index
    @menus = Menu.where(date: Date.today..DateTime::Infinity.new)
    @clients = Client.all
  end

  def new
    @menu = Menu.find(params[:menu_id])
    @menu_choice = MenuChoice.new
  end

  def create
    @menu = Menu.find(params[:menu_choice][:menu_id])
    params[:menu_choice][:client_id].each do |client_id|
      byebug
      MenuChoice.create(menu: @menu, client: Client.find(client_id)) if client_id != ""
    end
    # @menu_choice = MenuChoice.new(menu_choice_params)
    # raise
  end

  private

  def menu_choice_params
    params.require(:menu_choice).permit(:menu, :client)
  end
end

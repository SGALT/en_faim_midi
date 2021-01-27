class MenusController < ApplicationController
  before_action :set_menu, only: [:edit, :update, :destroy, :show]

  def index
    @menus = Menu.all
    @menus_future = Menu.where(date: Date.today..DateTime::Infinity.new)
  end

  def new
    @menu = Menu.new
    @menu.menu_items.build(category: "potage")
    @menu.menu_items.build(category: "entrée")
    @menu.menu_items.build(category: "plat")
    @menu.menu_items.build(category: "accompagnement")
    @menu.menu_items.build(category: "fromage")
    @menu.menu_items.build(category: "dessert")
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      redirect_to menus_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @menu.destroy
    redirect_to menus_path
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :date, menu_items_attributes:[:name, :category])
  end
end

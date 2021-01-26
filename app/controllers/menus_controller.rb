class MenusController < ApplicationController
  def index
    @menus = Menu.all
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
    byebug
    if @menu.save
      redirect_to menus_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :date, menu_items_attributes:[:name, :category])
  end
end

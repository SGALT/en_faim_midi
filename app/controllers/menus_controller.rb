class MenusController < ApplicationController
  before_action :set_menu, only: [:edit, :update, :destroy, :show]

  def index
    if params[:query].present?
      @menus_future = Menu.where(date: params[:query].to_date..(params[:query].to_date + 6)).order(:date)
    else
      @menus = Menu.all
      @menus_future = Menu.where(date: Date.today..DateTime::Infinity.new).order(:date)
    end
    headers = ['Type','Menu','Quantité']
    # data = set_data(@menus)
    respond_to do |format|
      format.html
      format.xlsx { render xlsx: SpreadsheetArchitect.to_xlsx(headers: headers, data: set_data(@menus)) }
    end
  end

  def new
    @menu = Menu.new
    @menu.menu_items.build(category: "potage", quantity: 0, position: 1)
    @menu.menu_items.build(category: "entrée", quantity: 0, position: 2)
    @menu.menu_items.build(category: "plat", quantity: 0, position: 3)
    @menu.menu_items.build(category: "accompagnement", quantity: 0, position: 4)
    @menu.menu_items.build(category: "fromage", quantity: 0, position: 5)
    @menu.menu_items.build(category: "dessert", quantity: 0, position: 6)
    @menu.menu_items.build(category: "pain", name: "pain", quantity: 0, position: 7)
  end

  def create
    @menu = Menu.new(menu_params)
    if Menu.where(date: @menu.date).where(name: @menu.name).empty?
      if @menu.save
        redirect_to menus_path
      else
        render :new
      end
    else
      flash[:alert] = "Impossible de créer 2 menus identiques sur une même date"
      redirect_to new_menu_path
    end
  end

  def show
  end

  def edit
  end

  def update
    params[:menu][:menu_items_attributes].each do |key, value|
      menu_item = MenuItem.find(value["id"])
      menu_item.update(category: value["category"], name: value["name"], quantity: value["quantity"])
    end
    redirect_to menus_path
  end

  def destroy
    @menu.destroy
    redirect_to menus_path
  end

  private

  def set_data(menus)
    types = ['POTAGE', 'ENTREE', 'PLAT', 'ACCOMPAGNEMENT', 'FROMAGE', 'DESSERT', 'PAIN']
    array = []
    menus.each do |menu|
      array << ["", "#{menu.name} -- #{menu.date}", ""]
      menu.menu_items.order(:position).each_with_index do |menu_item, index|
        array << [types[index], menu_item.name, menu_item.quantity.to_s]
      end
    end
    array
  end
  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :date, menu_items_attributes: [:name, :category, :quantity, :position])
  end
end

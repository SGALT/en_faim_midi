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
    @menu = Menu.find(params[:menu_choice][:menu])
    @menu_alt = Menu.where(date: @menu.date).where.not(name: @menu.name)
    params[:menu_choice][:client_id].each do |client_id|
      if client_id != ""
        client = Client.find(client_id)
        MenuChoice.create(menu: @menu, client: client) if client_id != ""
        case client.formule
        when "7C"
          @menu.menu_items.each do |menu_item|
            quantity = menu_item.quantity += 1
            menu_item.update(quantity: quantity)
          end
        when "2C"
          @menu.menu_items.each do |menu_item|
            if menu_item.category == "plat" || menu_item.category == "accompagnement"
              quantity = menu_item.quantity += 1
              menu_item.update(quantity: quantity)
            end
          end
        when "3C"
          if menu_item.category == "plat" || menu_item.category == "accompagnement" || menu_item.category == "pain"
            quantity = menu_item.quantity += 1
            menu_item.update(quantity: quantity)
          end
        when "10C entrée"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "entrée" || menu_item.category == "plat" || menu_item.category == "accompagnement"
              update_items(menu_item)
            end
          end
        when "10C potage"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "potage" || menu_item.category == "plat" || menu_item.category == "accompagnement"
              update_items(menu_item)
            end
          end
        when "10C dessert"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "dessert" || menu_item.category == "plat" || menu_item.category == "accompagnement"
              update_items(menu_item)
            end
          end
        end
      end
    end
    redirect_to menu_choices_path
    # @menu_choice = MenuChoice.new(menu_choice_params)
    # raise
  end

  private

  def menu_choice_params
    params.require(:menu_choice).permit(:menu, :client)
  end

  def update_items(menu_item)
    quantity = menu_item.quantity += 1
    menu_item.update(quantity: quantity)
  end
end

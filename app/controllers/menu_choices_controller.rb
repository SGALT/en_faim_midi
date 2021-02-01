class MenuChoicesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @menus = Menu.where(date: Date.today..DateTime::Infinity.new)
    @clients = Client.all
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def change
    @menu = Menu.find(params[:id])
    @menu_alt = Menu.where(date: @menu.date).where.not(name: @menu.name)
    @params_array = (params[:menu][:client_ids] - [""]).map { |str| str.to_i }
    @previous_array = @menu.clients.ids
    if @previous_array.count > @params_array.count
      results = @previous_array - @params_array
      results.each do |result|
        client = Client.find(result)
        @menu.menu_choices.find_by(client_id: result).destroy
        case client.formule
        when "7C"
          @menu.menu_items.each do |menu_item|
            quantity = menu_item.quantity -= 1
            menu_item.update(quantity: quantity)
          end
        when "2C"
          @menu.menu_items.each do |menu_item|
            if menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              quantity = menu_item.quantity -= 1
              menu_item.update(quantity: quantity)
            end
          end
        when "3C"
          if menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT" || menu_item.category == "PAIN"
            quantity = menu_item.quantity -= 1
            menu_item.update(quantity: quantity)
          end
        when "10C entrée"
          @menu.menu_items.each do |menu_item|
            minus_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "ENTREE" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              minus_items(menu_item)
            end
          end
        when "10C potage"
          @menu.menu_items.each do |menu_item|
            minus_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "POTAGE" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              minus_items(menu_item)
            end
          end
        when "10C dessert"
          @menu.menu_items.each do |menu_item|
            minus_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "DESSERT" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              minus_items(menu_item)
            end
          end
        end
      end
    elsif @params_array.count > @previous_array.count
      results = @params_array - @previous_array
      results.each do |result|
        client = Client.find(result)
        MenuChoice.create(menu: @menu, client: client)
        case client.formule
        when "7C"
          @menu.menu_items.each do |menu_item|
            quantity = menu_item.quantity += 1
            menu_item.update(quantity: quantity)
          end
        when "2C"
          @menu.menu_items.each do |menu_item|
            if menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              quantity = menu_item.quantity += 1
              menu_item.update(quantity: quantity)
            end
          end
        when "3C"
          if menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT" || menu_item.category == "PAIN"
            quantity = menu_item.quantity += 1
            menu_item.update(quantity: quantity)
          end
        when "10C entrée"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "ENTREE" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              update_items(menu_item)
            end
          end
        when "10C potage"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "POTAGE" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              update_items(menu_item)
            end
          end
        when "10C dessert"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "DESSERT" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              update_items(menu_item)
            end
          end
        end
      end
    end
    redirect_to menu_choices_path
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
            if menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              quantity = menu_item.quantity += 1
              menu_item.update(quantity: quantity)
            end
          end
        when "3C"
          if menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT" || menu_item.category == "PAIN"
            quantity = menu_item.quantity += 1
            menu_item.update(quantity: quantity)
          end
        when "10C entrée"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "ENTREE" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              update_items(menu_item)
            end
          end
        when "10C potage"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "POTAGE" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              update_items(menu_item)
            end
          end
        when "10C dessert"
          @menu.menu_items.each do |menu_item|
            update_items(menu_item)
          end
          @menu_alt.first.menu_items.each do |menu_item|
            if menu_item.category == "DESSERT" || menu_item.category == "PLAT" || menu_item.category == "ACCOMPAGNEMENT"
              update_items(menu_item)
            end
          end
        end
      end
    end
    redirect_to menu_choices_path
  end

  private

  def menu_choice_params
    params.require(:menu_choice).permit(:menu, :client)
  end

  def update_items(menu_item)
    quantity = menu_item.quantity += 1
    menu_item.update(quantity: quantity)
  end

  def minus_items(menu_item)
    quantity = menu_item.quantity -= 1
    menu_item.update(quantity: quantity)
  end
end

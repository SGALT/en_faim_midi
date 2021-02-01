class MenusController < ApplicationController
  before_action :set_menu, only: [:edit, :update, :destroy, :show]

  def index
    if params[:query].present?
      @menus_future = Menu.where(date: params[:query].to_date..(params[:query].to_date + 6)).order(:date)
      data(@menus_future)
    else
      @menus = Menu.all
      @menus_future = Menu.where(date: Date.today..DateTime::Infinity.new).order(:date)
    end
  end

  def new
    @menu = Menu.new
    @menu.menu_items.build(category: "POTAGE", quantity: 0, position: 1)
    @menu.menu_items.build(category: "ENTREE", quantity: 0, position: 2)
    @menu.menu_items.build(category: "PLAT", quantity: 0, position: 3)
    @menu.menu_items.build(category: "ACCOMPAGNEMENT", quantity: 0, position: 4)
    @menu.menu_items.build(category: "FROMAGE", quantity: 0, position: 5)
    @menu.menu_items.build(category: "DESSERT", quantity: 0, position: 6)
    @menu.menu_items.build(category: "PAIN", name: "pain", quantity: 0, position: 7)
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

  def data(menus)
    types = ['POTAGE', 'ENTREE', 'PLAT', 'ACCOMPAGNEMENT', 'FROMAGE', 'DESSERT', 'PAIN']
    array = []
    menus_1 = menus.where(name: "menu 1").order(:date)
    menus_2 = menus.where(name: "menu 2").order(:date)
    row_title_1 = []
    row_potage_1 = []
    row_entree_1 = []
    row_plat_1 = []
    row_acc_1 = []
    row_fromage_1 = []
    row_dessert_1 = []
    row_pain_1 = []
    row_separation = [""] * 28
    row_title_2 = []
    row_potage_2 = []
    row_entree_2 = []
    row_plat_2 = []
    row_acc_2 = []
    row_fromage_2 = []
    row_dessert_2 = []
    row_pain_2 = []
    menus_1.each do |menu|
      row_title_1 << ""
      row_title_1 << "#{menu.name} -- #{l(menu.date, format: '%d/%m/%Y')}"
      row_title_1 << ""
      row_title_1 << ""
      menu.menu_items.order(:position).each_with_index do |menu_item, index|
        case menu_item.category
        when "POTAGE"
          row_potage_1 << types[index]
          row_potage_1 << menu_item.name
          row_potage_1 << menu_item.quantity
          row_potage_1 << ""
        when "ENTREE"
          row_entree_1 << types[index]
          row_entree_1 << menu_item.name
          row_entree_1 << menu_item.quantity
          row_entree_1 << ""
        when "PLAT"
          row_plat_1 << types[index]
          row_plat_1 << menu_item.name
          row_plat_1 << menu_item.quantity
          row_plat_1 << ""
        when "ACCOMPAGNEMENT"
          row_acc_1 << types[index]
          row_acc_1 << menu_item.name
          row_acc_1 << menu_item.quantity
          row_acc_1 << ""
        when "FROMAGE"
          row_fromage_1 << types[index]
          row_fromage_1 << menu_item.name
          row_fromage_1 << menu_item.quantity
          row_fromage_1 << ""
        when "DESSERT"
          row_dessert_1 << types[index]
          row_dessert_1 << menu_item.name
          row_dessert_1 << menu_item.quantity
          row_dessert_1 << ""
        when "PAIN"
          row_pain_1 << types[index]
          row_pain_1 << menu_item.name
          row_pain_1 << menu_item.quantity
          row_pain_1 << ""
        end
      end
    end
    menus_2.each do |menu|
      row_title_2 << ""
      row_title_2 << "#{menu.name} -- #{l(menu.date, format: '%d/%m/%Y')}"
      row_title_2 << ""
      row_title_2 << ""
      menu.menu_items.order(:position).each_with_index do |menu_item, index|
        case menu_item.category
        when "POTAGE"
          row_potage_2 << types[index]
          row_potage_2 << menu_item.name
          row_potage_2 << menu_item.quantity
          row_potage_2 << ""
        when "ENTREE"
          row_entree_2 << types[index]
          row_entree_2 << menu_item.name
          row_entree_2 << menu_item.quantity
          row_entree_2 << ""
        when "PLAT"
          row_plat_2 << types[index]
          row_plat_2 << menu_item.name
          row_plat_2 << menu_item.quantity
          row_plat_2 << ""
        when "ACCOMPAGNEMENT"
          row_acc_2 << types[index]
          row_acc_2 << menu_item.name
          row_acc_2 << menu_item.quantity
          row_acc_2 << ""
        when "FROMAGE"
          row_fromage_2 << types[index]
          row_fromage_2 << menu_item.name
          row_fromage_2 << menu_item.quantity
          row_fromage_2 << ""
        when "DESSERT"
          row_dessert_2 << types[index]
          row_dessert_2 << menu_item.name
          row_dessert_2 << menu_item.quantity
          row_dessert_2 << ""
        when "PAIN"
          row_pain_2 << types[index]
          row_pain_2 << menu_item.name
          row_pain_2 << menu_item.quantity
          row_pain_2 << ""
        end
      end
    end
    p = Axlsx::Package.new
    wb = p.workbook
    headers = ['Type', 'Menu', 'Quantité', ""] * 7
    styles = wb.styles
    header_style = styles.add_style(bg_color: '646464', fg_color: "ffffff")
    wrap_text = styles.add_style(alignment: { horizontal: :center, vertical: :center, wrap_text: true })
    wb.add_worksheet(name: 'fiche de production') do |sheet|
      sheet.add_row headers, style: [header_style] * 28
      sheet.add_row row_title_1
      sheet.add_row row_potage_1
      sheet.add_row row_entree_1
      sheet.add_row row_plat_1
      sheet.add_row row_acc_1
      sheet.add_row row_fromage_1
      sheet.add_row row_dessert_1
      sheet.add_row row_pain_1
      sheet.add_row [""] * 28, style: [header_style] * 28
      sheet.add_row row_title_2
      sheet.add_row row_potage_2
      sheet.add_row row_entree_2
      sheet.add_row row_plat_2
      sheet.add_row row_acc_2
      sheet.add_row row_fromage_2
      sheet.add_row row_dessert_2
      sheet.add_row row_pain_2
    end
    send_data p.to_stream.read, type: "application/xlsx", filename: "en_faim_midi_fiche_production.xlsx"
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :date, menu_items_attributes: [:name, :category, :quantity, :position])
  end
end

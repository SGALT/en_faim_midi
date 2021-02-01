class ClientsController < ApplicationController
  before_action :set_client, only: [:edit, :update, :destroy]

  def index
    if params[:query] && params[:duration]
      @clients = Client.all
      p = Axlsx::Package.new
      wb = p.workbook
      styles = wb.styles
      wrap_text = styles.add_style(alignment: { horizontal: :center, vertical: :center, wrap_text: true })
      wb.add_worksheet(name: 'Planche étiquettes') do |sheet|
        @clients.each do |client|
          client.menus.where(date: params[:query].to_date..(params[:query].to_date + params[:duration].to_i)).order(:date).each do |menu|
            rt = Axlsx::RichText.new
            rt.add_run(client.name, b: true)
            rt.add_run("\n")
            rt.add_run("formule : #{client.formule} -- spécificité : #{client.specificity}")
            rt.add_run("\n")
            rt.add_run("#{menu.name} -- #{l(menu.date, format: '%d/%m/%Y')}")
            rt.add_run("\n")
            if client.formule.include?("10C")
              menu.menu_items.order(:position).each do |menu_item|
                rt.add_run("- #{menu_item.name}")
                rt.add_run("\n")
              end
              rt.add_run("Plats du soir")
              rt.add_run("\n")
              menu_alt = Menu.where(date: menu.date).where.not(name: menu.name).first
              rt.add_run(menu_alt.menu_items.find_by(category: "PLAT").name)
              rt.add_run("\n")
              rt.add_run(menu_alt.menu_items.find_by(category: "ACCOMPAGNEMENT").name)
              rt.add_run("\n")
              if client.formule == "10C entrée"
                rt.add_run(menu_alt.menu_items.find_by(category: "ENTREE").name)
                rt.add_run("\n")
              elsif client.formule == "10C potage"
                rt.add_run(menu_alt.menu_items.find_by(category: "POTAGE").name)
                rt.add_run("\n")
              elsif client.formule == "10C dessert"
                rt.add_run(menu_alt.menu_items.find_by(category: "DESSERT").name)
                rt.add_run("\n")
              end
            elsif client.formule.include?("2C")
              rt.add_run(menu.menu_items.find_by(category: "PLAT").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "ACCOMPAGNEMENT").name)
              rt.add_run("\n")
            elsif client.formule.include?("3C")
              rt.add_run(menu.menu_items.find_by(category: "PLAT").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "ACCOMPAGNEMENT").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "PAIN").name)
              rt.add_run("\n")
            elsif client.formule.include?("7C")
              rt.add_run(menu.menu_items.find_by(category: "POTAGE").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "ENTREE").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "PLAT").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "ACCOMPAGNEMENT").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "FROMAGE").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "DESSERT").name)
              rt.add_run("\n")
              rt.add_run(menu.menu_items.find_by(category: "PAIN").name)
              rt.add_run("\n")
            end
            sheet.add_row [rt], style: wrap_text
          end
        end
        sheet.rows.each { |row| row.height = 200 }
      end
      send_data p.to_stream.read, type: "application/xlsx", filename: "en_faim_midi_étiquettes.xlsx"
    else
      @clients = Client.all
    end
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.user_id = current_user.id
    if @client.save
      redirect_to clients_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path
    else
      render :edit
    end
  end

  def destroy
    @client.delete
    redirect_to clients_path
  end

  private

  def data_to_print
  end

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :formule, :specificity)
  end
end

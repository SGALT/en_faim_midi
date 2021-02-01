# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "cleaning database of Menus and Menu_choices"
Menu.destroy_all

puts "database clean !"

puts "Creating 7 menus...."

date = Date.today + 1
types = ['POTAGE', 'ENTREE', 'PLAT', 'ACCOMPAGNEMENT', 'FROMAGE', 'DESSERT', 'PAIN']
menu_items = ['Velouté légumes verts', 'Carottes cuites vinaigrette', 'Sauté de veau marengo', 'Pommes de terre sautées', 'Brie de Meaux', 'Raisins', 'pain']
menu_items_position = [1, 2, 3, 4, 5, 6, 7]

7.times do
  menu_1 = Menu.create(name: "menu 1", date: date)
  menu_2 = Menu.create(name: "menu 2", date: date)
  types.each_with_index do |type, index|
    MenuItem.create(category: type, name: menu_items[index], quantity:0, menu: menu_1, position: menu_items_position[index] )
    MenuItem.create(category: type, name: menu_items[index], quantity: 0, menu: menu_2, position: menu_items_position[index] )
  end
  date += 1
end

puts "everything ok !!"

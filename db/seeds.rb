# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



create_account = User.create([email: 'admin@qq.com', password: '12345678', password_confirmation: '12345678', is_admin: 'true', is_website_admin: 'true', username: 'admin'])
puts "Admin account created."

locations = Location.create([{ name: '北京'}, { name: '上海'}, { name: '深圳'}, { name: '广州'}, { name: '杭州'}, { name: '成都'}, { name: '香港'}, { name: '海外'}])
categorys = Category.create([{ name: '技术', icon: 'fa fa-laptop'}, { name: '产品', icon: 'fa fa-tasks'}, { name: '设计', icon: 'fa fa-photo'}, { name: '运营', icon: 'fa fa-line-chart'}, { name: '市场', icon: 'fa fa-pie-chart'}, { name: '销售', icon: 'fa fa-cny'}, { name: '职能', icon: 'fa fa-paste'}, { name: '其他', icon: 'fa fa-address-book-o'}])

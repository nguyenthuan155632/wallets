# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: 'abc@gmail.com', password: '123456', password_confirmation: '123456')

Trash.find_or_create_by(contract_name: 'Binance Coin')
Trash.find_or_create_by(contract_name: 'BUSD Token')
Trash.find_or_create_by(contract_name: 'Tether USD')

Network.find_or_create_by(network_name: 'Binance Smart Chain', chain_id: 56, user: user)
Network.find_or_create_by(network_name: 'Avalanche', chain_id: 43_114, user: user)

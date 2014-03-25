# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


AuthOption.create(id:1, name:'SSN', length:9)
AuthOption.create(id:2, name:'Area-Code', length:7)
AuthOption.create(id:3, name:'Phone-Number', length:13)
AuthOption.create(id:4, name:'Credit-card', length:16)
AuthOption.create(id:5, name:'Driver-License', length:20)
AuthOption.create(id:6, name:'Medicade', length:13)
AuthOption.create(id:7, name:'Medicare', length:10)

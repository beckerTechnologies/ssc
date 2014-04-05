# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


AuthOption.create(id:1, name:'Social Security Number', length:9)
AuthOption.create(id:2, name:'Area Code and Phone Number', length:10)
AuthOption.create(id:3, name:'Credit Card or Debit Card', length:16)
AuthOption.create(id:4, name:'Driver License', length:20)
AuthOption.create(id:5, name:'Medicade', length:13)
AuthOption.create(id:6, name:'Medicare', length:10)

Carrier.create(id:1, carrier_name:'Alltel', carrier_value:'alltel')
Carrier.create(id:2, carrier_name:'Ameritech', carrier_value:'ameritech')
Carrier.create(id:3, carrier_name:'AT&T', carrier_value:'at&t')
Carrier.create(id:4, carrier_name:'Bell Atlantic', carrier_value:'bell-atlantic')
Carrier.create(id:5, carrier_name:'Bellsouth Mobility', carrier_value:'bellsouthmobility')
Carrier.create(id:6, carrier_name:'BlueSkyFrog', carrier_value:'blueskyfrog')
Carrier.create(id:7, carrier_name:'Boost Mobile', carrier_value:'boost')
Carrier.create(id:8, carrier_name:'Cellular South', carrier_value:'cellularsouth')
Carrier.create(id:9, carrier_name:'Comcast PCS', carrier_value:'comcast')
Carrier.create(id:10, carrier_name:'Cricket', carrier_value:'cricket')
Carrier.create(id:11, carrier_name:'kajeet', carrier_value:'kajeet')
Carrier.create(id:12, carrier_name:'Metro PCS', carrier_value:'metropcs')
Carrier.create(id:13, carrier_name:'Nextel', carrier_value:'nextel')
Carrier.create(id:14, carrier_name:'Powertel', carrier_value:'powertel')
Carrier.create(id:15, carrier_name:'PSC Wireless', carrier_value:'pscwireless')
Carrier.create(id:16, carrier_name:'Qwest', carrier_value:'qwest')
Carrier.create(id:17, carrier_name:'Southern Link', carrier_value:'southernlink')
Carrier.create(id:18, carrier_name:'Sprint PCS', carrier_value:'sprint')
Carrier.create(id:19, carrier_name:'Suncom', carrier_value:'suncom')
Carrier.create(id:20, carrier_name:'T-Mobile', carrier_value:'t-mobile')
Carrier.create(id:21, carrier_name:'Tracfone', carrier_value:'tracfone')
Carrier.create(id:22, carrier_name:'Telus Mobility', carrier_value:'telus-mobility')
Carrier.create(id:23, carrier_name:'Virgin Mobile', carrier_value:'virgin')
Carrier.create(id:24, carrier_name:'Verizon Wireless', carrier_value:'verizon')

Lifetime.create(id:1, name:'12 Hours', hours:12)
Lifetime.create(id:2, name:'1 Day', hours:24)
Lifetime.create(id:3, name:'2 Day', hours:48)
Lifetime.create(id:4, name:'3 Day', hours:72)
Lifetime.create(id:5, name:'4 Day', hours:96)
Lifetime.create(id:6, name:'5 Day', hours:120)
Lifetime.create(id:7, name:'6 Day', hours:144)
Lifetime.create(id:8, name:'7 Day', hours:168)

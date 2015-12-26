# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


[
    :super_admin,
    :admin,
    :operator,
    :tech
].each do |admin_role|
  AdminRole.create(
               name: admin_role.to_s
  )
end
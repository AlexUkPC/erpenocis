# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.username
100.times do |j|
  employee = Employee.create(name: SecureRandom.hex(4), hire_date: Date.today, dismiss_date: Date.today)
  100.times do |i|
    EmployeeSalary.create(employee_id: employee.id, net_salary: rand(100), salary_tax: rand(100), meal_vouchers: rand(100), gift_vouchers: rand(100), overtime: rand(100), extra_salary: rand(100), date: Date.today-4.months+i.months)
  end
  print j.to_s+'|'
  
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.username
puts "Vrei sa adaugi angajati?(y)"
a = gets.chomp
if a=="y"
  puts "Cati?(number)"
  q = gets.chomp.to_i
  puts "Cate luni?(number)"
  qm = gets.chomp.to_i
  q.times do |j|
    employee = Employee.create(name: SecureRandom.hex(4), hire_date: Date.today, dismiss_date: Date.today)
    qm.times do |i|
      r = rand(100)
      if r<80
        EmployeeSalary.create(employee_id: employee.id, net_salary: rand(100), salary_tax: rand(100), meal_vouchers: rand(100), gift_vouchers: rand(100), overtime: rand(100), extra_salary: rand(100), date: Date.today-4.months+i.months)
      end
    end
    print j.to_s+'|' 
  end
end
puts "Vrei sa adaugi cheltuieli?(y)"
a = gets.chomp
if a=="y"
  puts "Cate?(number)"
  q = gets.chomp.to_i
  puts "Cate luni?(number)"
  qm = gets.chomp.to_i
  q.times do |j|
    expense = Expense.create(name: SecureRandom.hex(4),expense_type: rand(4))
    qm.times do |i|
      r = rand(100)
      if r<50
        ExpenseValue.create(expense_id: expense.id, value: rand(100)+1, date: Date.today-4.months+i.months, vat_taxes: false)
      end
    end
    print j.to_s+'|'
    
  end
end

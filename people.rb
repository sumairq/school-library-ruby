require_relative './student'
require_relative './teacher'

class People
  attr_accessor :list

  def initialize
    @list = []
  end

  def add_person(person)
    new_person = person.create_person
    @list << new_person
    # save_people_data(@list)
  end

  def filter_with_index(index)
    @list[index]
  end

  def filter_with_id(id)
    @list.select { |person| person.id == id }[0]
  end
end

class CreatePerson
  def create_person
    @age = 0
    until @age.positive?
      puts 'age: '
      @age = gets.chomp.to_i
    end
    puts 'Name:'
    @name = gets.chomp.strip.capitalize
  end
end

class CreateStudent < CreatePerson
  def create_person
    super
    permision = true
    input = ''
    if @age < 18
      until %w[Y N].include?(input)
        puts 'has parents permission?[Y,N]'
        input = gets.chomp.upcase
        permision = input == 'Y'
      end
    end
    Student.new({ 'classroom' => nil, 'age' => @age, 'id' => Random.rand(1..1000), 'name' => @name,
                  'parent_permission' => permision })
  end
end

class CreateTeacher < CreatePerson
  def create_person
    super
    puts 'Specialization:'
    specialization = gets.chomp.strip.capitalize
    Teacher.new({ 'specialization' => specialization, 'age' => @age, 'id' => Random.rand(1..1000), 'name' => @name })
  end
end

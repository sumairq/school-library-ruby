require_relative 'nameable'
require_relative 'base_decorator'
require_relative 'rental'

class Person < Nameable
  attr_reader :id
  attr_accessor :name, :age, :rentals, :parent_permission

  def initialize(age, id = Random.rand(1..1000), name = 'unknown', parent_permission: true)
    super()
    @age = age
    @id = id
    @name = name
    @parent_permission = parent_permission
    @rentals = []
  end

  def correct_name
    @name
  end

  def can_use_services?
    of_age? || parent_permission
  end

  def to_s
    "ID: #{@id} Name: #{@name} Age: #{age}"
  end

  def add_rentals(date, book)
    Rental.new({ 'date' => date, 'person' => self, 'book' => book })
  end

  private

  def of_age?
    @age >= 18
  end
end

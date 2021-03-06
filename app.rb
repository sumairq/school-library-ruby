require_relative './book'
require_relative './books'
require_relative 'people'
require_relative 'list_printer'
require_relative './rental'
require_relative 'storage'

class App
  def initialize
    @storage = Storage.new
    @books = Books.new
    @people = People.new
    @rentals = []
    @storage.read(@books, 'books.json')
    @storage.read(@people, 'people.json')
    @storage.rentals_read(@rentals, @people, @books, 'rentals.json')
    @num = 0
  end

  def start
    puts 'Welcome to School Library!'
    menu while @num != 7
  end

  private

  def menu
    puts "Please choose an option by entering a number\n1- List all books\n2- List all people\n3- Create a person
4- Create a book\n5- Create a rental\n6- List all rentals\n7- exit"
    @num = gets.chomp.to_i

    case @num.to_i
    when 1 then ListPrinter.print_list(@books.list)
    when 2 then ListPrinter.print_list(@people.list)
    when 3 then add_person
    when 4 then @books.add_book
    when 5 then create_rental
    when 6 then list_rentals
    when 7 then handle_exit
    end
  end

  def add_person
    puts 'Do you want to create a student(1) or a teacher(2)?[input the number]'
    input = gets.chomp.to_i
    while input > 2 || input < 1
      puts 'Please input correct choice'
      input = gets.chomp.to_i
    end
    @people.add_person(input == 1 ? CreateStudent.new : CreateTeacher.new)
    reset
  end

  def create_rental
    book_index = -1
    person_index = -1
    # list_of_book = read_books_data
    puts 'select a book from the following list by number'
    ListPrinter.print_list(@books.list)
    until book_index > -1 && book_index < @books.list.length
      puts 'book index:'
      book_index = gets.chomp.to_i
    end
    puts 'select a person from the following list by number'
    # list_of_people =
    ListPrinter.print_list(@people.list)
    until person_index > -1 && person_index < @people.list.length
      puts 'person index:'
      person_index = gets.chomp.to_i
    end
    puts 'date: (YYYY/MM/DD): '
    date = gets.chomp
    # Changes made
    # Before
    # Rental.new(date, @people.filter_with_index(person_index), @books.filter_with_index(book_index))
    # After
    @rentals << Rental.new({ 'date' => date, 'person' => @people.filter_with_index(person_index),
                             'book' => @books.filter_with_index(book_index) })

    #  save_rentals_data(@rentals)
    # End
    puts 'Rental created succesfully'

    reset
  end

  def reset
    puts 'press enter to continue to main menu'
    gets.chomp
    @num = 0
  end

  def list_rentals
    id = 0
    until id.positive?
      puts 'id of person: '
      ListPrinter.print_list(@people.list)
      id = gets.chomp.to_i
    end
    puts 'rentals: '
    # ListPrinter.print_list(@people.list)
    @people.filter_with_id(id).rentals.each do |rental|
      puts "Date: #{rental.date}, book: #{rental.book.title} by #{rental.book.author}"
    end
    reset
  end

  def handle_exit
    @storage.write(@books.list, 'books.json')
    @storage.write(@people.list, 'people.json')
    @storage.write(@rentals, 'rentals.json')
  end
end

require 'json'
require 'fileutils'
class Storage
  def write(list, file)
    opts = { array_nl: "\n", object_nl: "\n", indent: ' ', space_before: ' ', space: ' ' }
    serializedlist = JSON.generate(list.map(&:to_object), opts)
    FileUtils.touch(file) unless File.exist?(file)
    File.write(file, serializedlist)
  end

  def read(component, file)
    return unless File.exist?(file)

    content = File.read(file)
    list = JSON.parse(content)

    component.list = list.map { |item| Kernel.const_get(item['class_name']).new(item['opt']) }
  end

  def rentals_read(_rentals, people, books, file)
    return unless File.exist?(file)

    content = File.read(file)
    list = JSON.parse(content)

    _rentals = list.map do |item|
      Rental.new({ 'date' => item['date'], 'person' => people.filter_with_id(item['person']),
                   'book' => books.filter_with_title(item['book']) })
    end
  end
end

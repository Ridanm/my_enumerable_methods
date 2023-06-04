module MyEnumerable

  def my_each
    return to_enum(__callee__) unless block_given?
    indx = 0
    while indx < size
      yield self[indx]
      indx += 1
    end
      self
  end

  def my_each_with_index(&block)
    return to_enum(__callee__) unless block_given?
    indx = 0
    while indx < size
      block.call self[indx], indx 
      indx += 1
    end
    self 
  end

  def my_select(&block)
    return to_enum() unless block_given?
    result = []
    self.each do |element|
      result << element if block.call(element)
    end
    result
  end

  def my_all?(&block)
    return to_enum() unless block_given?  
    self.each do |element|
      return false unless block.call(element)
    end
     return true 
  end

  def my_any?(&block)
    return to_enum() unless block_given?
    self.each do |element|
      return true if block.call(element) 
    end
    return false 
  end 

  def my_none?(&block)
    return to_enum(__callee__) unless block_given?
    self.each do |element|
      return false if block.call(element) 
    end
    return true
  end

  def my_count(&block)
    return self.size unless block_given?
    count = 0
    self.each do |element|
      count += 1 if block.call(element) 
    end
    count 
  end

  def my_map(&block)
    return to_enum(__callee) unless block_given?
    result = []
    self.each do |element|
      result << block.call(element)
    end
    result
  end

  def my_inject(value_initial=nil, &block)
    return to_enum(__callee__) unless block_given?
    acc = value_initial || 0
    skip_first = value_initial.nil?

    self.each do |element| 
      next if skip_first && !value_initial.nil? 
      acc = block.call(acc, element)
      skip_first = false 
    end
    acc 
  end

end 

class Array
  include Enumerable 
  include MyEnumerable
end

puts 'Enumerator mode for my_inject: '
numbers = [1, 2, 3, 4, 5]
each_element = numbers.my_inject

indx = 0
all_elements = each_element.count
all_elements.times do 
  puts "Index: #{indx} Element: #{each_element.next[1]}"
  indx += 1
  break if indx == all_elements
end


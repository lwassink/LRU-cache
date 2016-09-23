class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    hash = 0
    self.each_with_index do |el, idx|
      hash = hash ^ (idx + el.hash).hash
    end
    hash
  end
end

class String
  def hash
    self.chars.map { |char| char.ord }.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    new_arr = self.each_pair.to_a
    new_arr.sort.hash
  end
end

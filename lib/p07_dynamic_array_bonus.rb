class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  attr_reader :count
  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
    @push_index = 0
    @shift_index = capacity - 1
  end

  def [](i)
    return nil unless i.between?(-length, length - 1)
    if i >= 0
      @store[(@shift_index + i + 1) % capacity]
    else
      @store[(@push_index + i) % capacity]
    end
  end

  def []=(i, val)
    if i.between?(0, length - 1)
      @store[(@shift_index + i + 1) % capacity] = val
    elsif i.between?(-length, -1)
      @store[(@push_index + i) % capacity] = val
    elsif i < -length
      raise IndexError, "index #{i} is too small for array"
    else
      push(nil) until count == i
      push(val)
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    each do |el|
      return true if el == val
    end
    false
  end

  def push(val)
    resize! if @count == capacity
    @store[@push_index] = val
    @push_index = (@push_index + 1) % capacity
    @count += 1
  end

  def unshift(val)
    resize! if @count == capacity
    @store[@shift_index] = val
    @shift_index = (@shift_index - 1) % capacity
    @count += 1
  end

  def pop
    @push_index = (@push_index - 1) % capacity
    popped = @store[@push_index]
    @store[@push_index] = nil
    @count -= 1
    popped
  end

  def shift
    @shift_index = (@shift_index + 1) % capacity
    shifted = @store[@shift_index]
    @store[@shift_index] = nil
    @count -= 1
    shifted
  end

  def first
    self[0]
  end

  def last
    self[-1]
  end

  def length
    @count
  end

  def each
    @count.times do |idx|
      yield self[idx]
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless length = other.length

    length.times do |idx|
      return false unless self[idx] == other[idx]
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_store = StaticArray.new(capacity * 2)
    length.times do |idx|
      new_store[idx] = self[idx]
    end
    @store = new_store
    @push_index = length
    @shift_index = capacity - 1
  end
end

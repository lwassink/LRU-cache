require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(el)
    unless include?(el)
      @count += 1
      self[el] << el
    end

    resize! if @count > num_buckets
  end

  def remove(el)
    @count -= 1 if self[el].delete(el)
  end

  def include?(el)
    self[el].include?(el)
  end

  private

  def [](el)
    # optional but useful; return the bucket corresponding to `el`
    @store[el.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_length = 2 * num_buckets
    new_store = Array.new(new_length) { Array.new }

    @store.each do |bucket|
      bucket.each do |el|
        new_store[el.hash % new_length] << el
      end
    end

    @store = new_store
  end
end

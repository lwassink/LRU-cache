require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    any? { |link_key, _| link_key == key }
  end

  def set(key, val)
    if link = get_link(key)
      link.val = val
    else
      bucket(key).insert(key, val)
      @count += 1
    end

    resize! if @count > num_buckets
  end

  def get(key)
    link = get_link(key)
    return nil if link.nil?
    link.val
  end

  def delete(key)
    link = get_link(key)
    return if link.nil?
    bucket(key).remove(key)
    @count -= 1
  end

  def each
    @store.each do |bucket|
      bucket.each do |link|
        yield [link.key, link.val]
      end
    end
    self
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_length = 2 * num_buckets
    new_store = Array.new(new_length) { LinkedList.new }

    @store.each do |bucket|
      bucket.each do |link|
        new_store[link.key.hash % new_length].insert(link.key, link.val)
      end
    end

    @store = new_store
  end

  def get_link(key)
    bucket(key).each { |link| return link if link.key == key }
    nil
  end

  def bucket(key)
    @store[key.hash % num_buckets]
    # optional but useful; return the bucket corresponding to `key`
  end
end

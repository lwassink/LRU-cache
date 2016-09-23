class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    link = get_link(key)
    return nil if link.nil?
    link.val
  end

  def include?(key)
    any? { |link| link.key == key }
  end

  def insert(key, val)
    if link = get_link(key)
      link.value = val
    else
      new_link = Link.new(key, val)
      old_tail_prev = @tail.prev

      old_tail_prev.next = new_link
      new_link.prev = old_tail_prev
      new_link.next = @tail
      @tail.prev = new_link
    end
  end

  def remove(key)
    link = get_link(key)
    return if link.nil?

    link.prev.next = link.next
    link.next.prev = link.prev
  end

  def each
    current_link = @head.next
    until current_link == @tail
      yield current_link
      current_link = current_link.next
    end
    self
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end

  private

  def get_link(key)
    each do |link|
      return link if link.key == key
    end
    nil
  end
end

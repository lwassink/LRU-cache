require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      update_link!(@map[key])
    else
      calc!(key)
    end
    @map[key].val
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    @store.insert(key, @prc.call(key))
    @map[key] = @store.last
    eject! if count > @max
  end

  def update_link!(link)
    # suggested helper method; move a link to the end of the list
    link.next.prev = link.prev
    link.prev.next = link.next

    @store.insert(link.key, link.val)
    @map[link.key] = @store.last
  end

  def eject!
    key = @store.first.key
    @store.remove(key)
    @map.delete(key)
  end
end

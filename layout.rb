class Layout
  def initialize(*floors)
    @floors = floors
    @ranges = floors.map do |floor|
      [(floor.left .. floor.left + floor.width), floor.top]
    end
  end

  def floor_at(x, y)
    @ranges
      .select { |(range, _)| range.include?(x) }
      .sort   { |(_, top)| top }
      .reject { |(_, top)| top < y }
      .inject(nil) { |memo, (_, top)| memo || top }
  end
end

__END__
Floor = Struct.new(:left, :top, :width, :height)

floor = Floor.new(0, 450, 500, 10)
another = Floor.new(10, 300, 100, 10)
layout = Layout.new(floor, another)

fail "Painfully" unless layout.floor_at(0, 0) == 450
fail "Painfully" unless layout.floor_at(10, 0) == 300
fail "Painfully" unless layout.floor_at(110, 0) == 300
fail "Painfully" unless layout.floor_at(111, 0) == 450
fail "Painfully" unless layout.floor_at(1000, 0) == nil

puts "Success!"

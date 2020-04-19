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

  def check_collisions(player, dx, dy)
    player_h = (player.left + dx .. player.left + dx + player.width)
    player_v = (player.top  + dy .. player.top  + dy + player.height)

    collisions = @floors.select do |floor|
      overlaps?(horizontal_range(floor), player_h) &&
        overlaps?(vertical_range(floor), player_v)
    end

    if collisions.any?
      if dy > 0  # Falling
        top_floor = collisions
          .reject { |floor| floor.top < player_v.begin }
          .min_by(&:top)

        if top_floor
          print "."
          dy = top_floor.top - player.top - player.height
        end
      elsif dy < 0  # Jumping
        bottom_floor = collisions
          .reject { |floor| floor.top >= player_v.end }
          .max_by(&:top)

        if bottom_floor
          print "^"
          dy = (bottom_floor.top + bottom_floor.height) - player.top
        end
      end

      if dx > 0 # Right
        bump = collisions
          .reject { |floor| floor.left <= player_h.begin }
          .max_by(&:left)

        if bump
          require 'pry';binding.pry;
          dx = bump.left - (player.left + player.width)
        end
      elsif dx < 0 # Left
        bump = collisions
          .reject { |floor| floor.absolute_right > player_h.end }
          .max_by(&:absolute_right)

        if bump
          dx = (bump.left + bump.width) - player.left
        end
      end
    end

    return [dx, dy]
  end

  def horizontal_range(object)
    object.left .. object.left + object.width
  end

  def vertical_range(object)
    object.top .. object.top + object.height
  end

  def overlaps?(r1, r2)
    r1.cover?(r2.first) || r2.cover?(r1.first)
  end
end

__END__
Floor = Struct.new(:left, :top, :width, :height)
Player = Floor

floor = Floor.new(0, 450, 500, 10)
another = Floor.new(10, 300, 100, 10)
layout = Layout.new(floor, another)

fail "Painfully" unless layout.floor_at(0, 0) == 450
fail "Painfully" unless layout.floor_at(10, 0) == 300
fail "Painfully" unless layout.floor_at(110, 0) == 300
fail "Painfully" unless layout.floor_at(111, 0) == 450
fail "Painfully" unless layout.floor_at(1000, 0) == nil

player = Player.new(0, 400, 50, 50)
fail "Painfully" unless layout.check_collisions(player, 0, 20) == [0, 0]

puts "Success!"

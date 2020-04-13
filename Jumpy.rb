require_relative "layout"

Shoes.app do
  background(white)

  @actions = {}
  @player = [
    rect(0, 440, 50, 50, fill: pink, stroke: blue),
    rect(10, 450, 10, 10, fill: black),
  ]

  @layout = Layout.new(
    rect(0, 490, 300, 5),
    rect(100, 430, 300, 5),
  )

  @status = para ""

  @loop = every 0.01 do
    @status.text = @actions.inspect

    proposed_x = 0
    proposed_y = 0

    @actions.each do |name, action|
      dx, dy = action.next
      proposed_x += dx
      proposed_y += dy
    rescue StopIteration
      action.rewind
      @actions.delete(name)
    end

    # HACK: First element is bounding box for player. Make a class you!
    player_box = @player.first
    player_bottom = player_box.top + player_box.height
    player_middle = player_box.left + proposed_x + (player_box.width / 2)

    floor = @layout.floor_at(player_middle, player_bottom)
    if floor.nil?
      game_over
    elsif player_bottom + proposed_y > floor
      proposed_y = floor - player_bottom
      stop_falling
    elsif proposed_y == 0 && player_bottom < floor
      falling
    end

    @player.each do |part|
      part.left += proposed_x
      part.top += proposed_y
    end
  end

  keyrelease do |key|
    case key
    when :right, :left, :shift_right, :shift_left,
         "h", "j", "k", "l", "H", "J", "K", "L"
      stop_walking
    end
  end

  keypress do |key|
    case key
    when :right, :left, "h", "l"
      walk(key)
    when :shift_right, :shift_left, "H", "L"
      run(key)
    when " ", "k", "K"
      jump
    end
  end

  def game_over
    @loop.stop
    @player.each(&:remove)
    background(gray)
    para "GAME OVER", align: "center", size: 100, top: 100
  end

  @noop       = Enumerator.new { |y| loop { y << [0, 0] } }

  @walk_right = Enumerator.new { |y| loop { y << [5, 0] } }
  @walk_left  = Enumerator.new { |y| loop { y << [-5, 0] } }
  @run_right  = Enumerator.new { |y| loop { y << [10, 0] } }
  @run_left   = Enumerator.new { |y| loop { y << [-10, 0] } }

  def stop_walking
    @actions[:walk] = @noop
  end

  def walk(direction)
    dx = is_right?(direction) ? @walk_right : @walk_left
    @actions[:walk] = dx
  end

  def run(direction)
    dx = is_right?(direction) ? @run_right : @run_left
    @actions[:walk] = dx
  end

  def is_right?(direction)
    return direction == :right || direction == :shift_right ||
           direction == "l" || direction == "L"
  end

  @jump = [
    [0, -20], [0, -20], [0, -20], [0, -20], [0, -20],
    [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]
  ].each

  def jump
    if @actions[:jump].nil?
      @actions[:jump] = @jump
    end
  end

  @falling = Enumerator.new { |y| loop { y << [0, 20] } }

  def falling
    @actions[:falling] = @falling
  end

  def stop_falling
    @actions.delete(:falling)
  end
end

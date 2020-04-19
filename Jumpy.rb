require_relative "layout"

Shoes.app do
  @actions = {
    gravity: Enumerator.new { |y| loop { y << [0, 20] } }
  }

  @player = [
    rect(50, 440, 50, 50, fill: pink, stroke: blue),
    rect(60, 450, 10, 10, fill: black),
  ]

  @layout = Layout.new(
    rect(0, 300, 5, 190),
    rect(0, 490, 300, 5),
    rect(200, 430, 300, 5),
  )

  @status = para ""

  @loop = every 0.01 do
    @status.text = @actions.inspect

    proposed_dx = 0
    proposed_dy = 0

    @actions.each do |name, action|
      dx, dy = action.next
      proposed_dx += dx
      proposed_dy += dy
    rescue StopIteration
      action.rewind
      @actions.delete(name)
    end

    # HACK: First element is bounding box for player. Make a class you!
    player_box = @player.first
    actual_dx, actual_dy = @layout.check_collisions(player_box,
                                                    proposed_dx, proposed_dy)

    p [actual_dx, actual_dy]

    @player.each do |part|
      part.left += actual_dx
      part.top += actual_dy
    end

    if @player.first.top > 2 * app.height
      game_over
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
    [0, -40], [0, -40], [0, -40], [0, -40], [0, -40],
    [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]
  ].each

  def jump
    if @actions[:jump].nil?
      @actions[:jump] = @jump
    end
  end
end

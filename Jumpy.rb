Shoes.app do
  @actions = {}
  @player = rect 0, 450, 50, 50, fill: pink, stroke: blue

  @status = para ""

  every 0.01 do
    @status.text = @actions.inspect

    @actions.each do |name, steps|
      begin
        dx, dy = steps.next
        @player.left += dx
        @player.top += dy
      rescue StopIteration
        steps.rewind
        @actions.delete(name)
      end
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
    [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0],
    [0, 20], [0, 20], [0, 20], [0, 20], [0, 20],
  ].each

  def jump
    if @actions[:jump].nil?
      @actions[:jump] = @jump
    end
  end
end

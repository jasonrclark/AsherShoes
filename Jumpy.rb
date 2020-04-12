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
    when :right, :left
      stop_walking
    end
  end

  keypress do |key|
    case key
    when :right, :left
      walk(key)
    when " "
      jump
    end
  end

  @noop       = Enumerator.new { |y| loop { y << [0, 0] } }
  @walk_right = Enumerator.new { |y| loop { y << [6, 0] } }
  @walk_left  = Enumerator.new { |y| loop { y << [-6, 0] } }

  def stop_walking
    @actions[:walk] = @noop
  end

  def walk(direction)
    dx = (direction == :right) ? @walk_right : @walk_left
    @actions[:walk] = dx
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

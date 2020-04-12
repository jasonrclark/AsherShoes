Shoes.app do
  @colors = [red, yellow, blue, orange, green, purple]

  @loops = []
  @falling = []
  @ground = rect(0, 450, 10000, 10000, fill: brown)

  @loops << every(5) do
    add_block unless @loops.empty?
  end

  @loops << every(0.01) do
    @falling.each do |fall|
      fall.top += 4

      if (fall.top + fall.height) > @ground.top
        remove_block(fall)
        bump_ground

        add_block unless finished?
      end

      if finished?
        clean_up
        para "GAME OVER", top: app.height / 2, size: 48, align: "center"
      end
    end
  end

  def add_block
    left = rand(app.width - 90)
    new_block = rect(left, 0, 90, 50, fill: @colors.sample)

    new_block.click do
      remove_block(new_block)
    end

    @falling << new_block
  end

  def remove_block(block)
    @falling.delete(block)
    block.remove
  end

  def finished?
    @ground.top <= 0
  end

  def bump_ground
    @ground.top -= 15
  end

  def clean_up
    @loops.clear

    @falling.each do |fall|
      remove_block(fall)
    end
  end

  add_block
end

Shoes.app do
  falling = []
  falling << rect(100, 0, 90, 50, fill: blue)

  rect(0, 450, 10000, 10000, fill: brown)
  every(0.01) do
    falling.each do |fall|
      fall.top += 2
    end
  end

  # Blocks different colors
  # When a block finishes, start another
  # Random positions for blocks when they start
  # Draw Ground!!
  # Ground moves UP when a block touches it
  # Game ends when ground touches the top of the screen
  # background city
  #
end

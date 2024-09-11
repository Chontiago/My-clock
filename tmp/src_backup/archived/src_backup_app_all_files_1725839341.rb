all_files = ["app/borders.rb", "app/bounce.rb", "app/buttons.rb","app/clock.rb", "app/slide.rb", "app/text.rb", "app/expand.rb", "app/change_color"]

all_files.each do |file|
  require file
end
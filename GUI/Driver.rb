# Created on 2/17/2020 by Linda Wang
# Edited on 2/18/2020 by Linda: Updated requires

require_relative 'EventsDisplay.rb'

# Runs the game all the way from the beginning
if __FILE__ == $0
  FXApp.new do |app|
    EventsDisplay.new app
    app.create
    app.run
  end
end

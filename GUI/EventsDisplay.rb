# Created 2/18/20 by Linda Wang
# Edited 2/19/20 by Linda Wang

require 'fox16'
require 'fox16/colors'
include Fox

require_relative 'FilterDisplay.rb'
require_relative 'AllEventsView.rb'
require_relative 'GetEmailDisplay.rb'
require_relative '../source/scrape.rb'
require_relative '../source/calendar.rb'

# Displays the events window, which shows the details of each event
class EventsDisplay < FXMainWindow

  # Created 2/18/20 by Linda Wang
  # Edited 2/19/20 by Linda: GUI now displays all events
  # Sets up the GUI for displaying events
  def initialize(app)

    # Initializes main window
    super app, 'DTix Display', width: 720, height: 580

    init_common app

    # Sets background color to white
    self.backColor = FXColor::White

  end

  # Created 2/19/20 by Linda Wang
  # Displays the window
  def create
    super
    show PLACEMENT_SCREEN
  end

  # Created on 2/19/20 by Linda Wang
  def init_common(app)

    # Creates the menu bar where the game can be paused or terminated
    @file_menu = FXMenuPane.new self, opts: FRAME_NONE
    menu_bar = FXMenuBar.new self, LAYOUT_SIDE_TOP | LAYOUT_FILL_X, opts: FRAME_NONE, padTop: 5, padBottom: 5
    menu_title = FXMenuTitle.new menu_bar, 'File', popupMenu: @file_menu, opts: FRAME_NONE

    # sets the color scheme for the first dropdown
    @file_menu.backColor = FXColor::White
    @file_menu.borderColor = FXColor::White
    @file_menu.shadowColor = FXColor::White
    @file_menu.hiliteColor = FXColor::White
    @file_menu.frameStyle = 0

    menu_bar.backColor = FXColor::White
    menu_bar.shadowColor = FXColor::White
    menu_bar.baseColor = FXColor::White
    menu_bar.borderColor = FXColor::White
    menu_bar.hiliteColor = FXColor::White

    menu_title.backColor = FXColor::White
    menu_title.shadowColor = FXColor::White
    menu_title.selBackColor = FXColor::LightSkyBlue2

    filter = FXMenuCommand.new @file_menu, 'Filter'
    send_calendar = FXMenuCommand.new @file_menu, 'Send Events to Calendar'
    end_program = FXMenuCommand.new @file_menu, 'End Program'

    filter.backColor = FXColor::White
    filter.selBackColor = FXColor::LightSkyBlue3

    send_calendar.backColor = FXColor::White
    send_calendar.selBackColor = FXColor::LightSkyBlue3

    end_program.backColor = FXColor::White
    end_program.selBackColor = FXColor::LightSkyBlue3

    # If the user wants to filter, open the filter dialog
    filter.connect SEL_COMMAND do

      filter_window = FilterDisplay.new app
      filter_window.create
      user_choice = filter_window.execute

      unless user_choice.zero?
          @events = []
          filter_window.start_date.strip.empty? ? (start_date = nil) : (start_date = DateTime.strptime(filter_window.start_date.strip, '%m/%d/%Y'))
          filter_window.end_date.strip.empty? ? (end_date = nil) : (end_date = DateTime.strptime(filter_window.end_date.strip, '%m/%d/%Y'))
          filter_window.min_price.strip.empty? ? (min_price = nil) : (min_price = filter_window.min_price.to_f)
          filter_window.max_price.strip.empty? ? (max_price = nil) : (max_price = filter_window.max_price.to_f)

          sold_out = filter_window.sold_out_events
          event_types = filter_window.event_types

          filtered_events = EventParse.filter start_date, end_date, min_price, max_price, sold_out, event_types
          @all_events.clear_all_events
          filtered_events.each_with_index {|event, index| @all_events.init_event event, index}
          create
      end
    end

    send_calendar.connect SEL_COMMAND do
      email_window = GetEmailDisplay.new app
      email_window.create
      user_choice = email_window.execute

      unless user_choice.zero?
        Calendar.write_file @all_events.selected_events.values.map {|value| value.event}
        Calendar.email_user email_window.to_s
      end
    end

    # If the user wants to quit, just terminate the program
    end_program.connect SEL_COMMAND do
      exit
    end

    # Creates the playing board area of the GUI which will hold the board view
    @all_events = AllEventsView.new self
    @all_events.backColor = FXColor::White

  end


end

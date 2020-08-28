require 'mechanize'

# Created 2/19/20 by Linda Wang

require_relative 'EventView.rb'
require_relative 'EventDetailsDisplay.rb'
require_relative '../source/scrape.rb'

# Displays the events
class AllEventsView < FXScrollWindow

  attr_accessor :selected_events, :arr_event_views

  def initialize p

     super p, opts:LAYOUT_FILL
     @matrix = FXMatrix.new self, padLeft: 20, padRight: 20, opts: LAYOUT_CENTER_X|MATRIX_BY_COLUMNS

     # Array of indices of the selected events
     @selected_events = {}

     # Array that holds each specific event 'card'
     @arr_event_views = []

     agent = Mechanize.new
     EventParse.multiple_pages agent

     # Initializes each card in the board (loads the image)
     EventParse.class_variable_get(:@@events).each_with_index { |event, index| init_event event, index }

     # Sets background color to white
     self.backColor = FXColor::White
     @matrix.backColor = FXColor::White

  end

  # Created 2/19/20 by Linda Wang
  def layout
    contentWindow.numColumns = 3
    super
  end

  # Created 2/19/20 by Linda Wang
  def init_event event, index

    # Creates a CardView to show the card
    event_view = EventView.new contentWindow, event, index
    event_view.event_image.enable

    # Event for when a card is selected or unselected
    event_view.event_image.connect SEL_LEFTBUTTONPRESS do

      event_view.selected ? (@selected_events.delete index) : (@selected_events[index] = event_view)

      # Update selected status and change its image
      event_view.selected = !event_view.selected
      event_view.select_image

    end

    # Event for when a card is selected or unselected
    event_view.event_image.connect SEL_RIGHTBUTTONPRESS do

      details = EventDetailsDisplay.new app, event
      details.create

    end

    # Adds the card to the array of cards the board holds
    @arr_event_views << event_view

  end

  # Created 2/19/20 by Linda Wang
  # Clears the entire board
  def clear_all_events

    @arr_event_views.each {|event_view| removeChild event_view}

    @selected_events.clear
    @arr_event_views.clear
  end

end

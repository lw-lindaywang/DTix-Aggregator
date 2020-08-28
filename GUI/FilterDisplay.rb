# Created 2/17/2020 by Linda Wang
# Edited 2/18/2020 by Linda Wang

require 'fox16'
require 'fox16/colors'
require 'date'
include Fox

# Dialog box that opens up if the user wants to only get specific types of events
class FilterDisplay < FXDialogBox

  # Created 2/17/2020 by Linda Wang
  # Edited 2/18/2020 by Linda: Finished the GUI layout
  # Initializes and creates GUI elements for this window
  def initialize app

    # Uses the FXDialogBox constructor to initalize itself
    super app, 'Filter', height: 490, width: 430

    # Sets background color to white
    self.backColor = FXColor::White

    # A checkbox users can check if they only want to see lottery events
    @checkbox_sold_out = FXCheckButton.new self, '', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    @checkbox_sold_out.x = 30
    @checkbox_sold_out.y = 25
    @checkbox_sold_out.boxColor = FXColor::White
    @checkbox_sold_out.backColor = FXColor::White

    # This label displays the text "Display sold out events?"
    label_sold_out = FXLabel.new self, "Display sold out events?", opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_sold_out.x = @checkbox_sold_out.x + 25
    label_sold_out.y = @checkbox_sold_out.y - 2
    label_sold_out.backColor = FXColor::White

    # This label displays the text "Type of Event"
    label_event_type = FXLabel.new self, "Type of Event", opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_event_type.x = @checkbox_sold_out.x
    label_event_type.y = label_sold_out.y + 35
    label_event_type.backColor = FXColor::White
    label_event_type.textColor = FXColor::DarkRed
    label_event_type.font = FXFont.new app, 'Calibri,140,Light'

    # Array of strings for label texts
    event_categories = %w[Special Sports Arts Concerts]

    # These checkboxes are for the categories of events
    @array_checkbox_event_types = []

    # These labels display the categories of events
    array_label_event_types = []

    4.times do |index|
      @array_checkbox_event_types[index] = FXCheckButton.new self, '', padLeft: event_categories[index-1].length * 2.5, opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
      @array_checkbox_event_types[index].x = @checkbox_sold_out.x + index * 90
      @array_checkbox_event_types[index].y = label_event_type.y + 50
      @array_checkbox_event_types[index].boxColor = FXColor::White
      @array_checkbox_event_types[index].backColor = FXColor::White

      array_label_event_types[index] = FXLabel.new self, event_categories[index], opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
      array_label_event_types[index].x = @array_checkbox_event_types[index].x + 20 + event_categories[index-1].length * 2.5
      array_label_event_types[index].y = @array_checkbox_event_types[index].y - 2
      array_label_event_types[index].backColor = FXColor::White
    end

    # This label displays the text "Date Range"
    label_date = FXLabel.new self, 'Date Range', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_date.x = @checkbox_sold_out.x
    label_date.y = @array_checkbox_event_types[0].y + 40
    label_date.backColor = FXColor::White
    label_date.textColor = FXColor::DarkRed
    label_date.font = FXFont.new app, 'Calibri,140,Medium'

    # This text field allows the user to enter in the starting date
    @text_start_date = FXTextField.new self, 15, opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    @text_start_date.x = label_date.x + 20
    @text_start_date.backColor = FXColor::LightGrey
    @text_start_date.y = label_date.y + 40
    @text_start_date.font = FXFont.new app, 'Calibri,100,Light'

    # This label displays the text "to" to specify a range of dates
    label_to_date = FXLabel.new self, 'to', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_to_date.x = label_date.x + 175
    label_to_date.y = @text_start_date.y
    label_to_date.backColor = FXColor::White
    label_to_date.textColor = FXColor::Black

    # This text field allows the user to enter in the ending date
    @text_end_date = FXTextField.new self, 15, opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    @text_end_date.x = @text_start_date.x + 190
    @text_end_date.backColor = FXColor::LightGrey
    @text_end_date.y = @text_start_date.y
    @text_end_date.font = FXFont.new app, 'Calibri,100,Light'

    # This label displays the text "Please enter a valid date (mm/dd/yyyy)." if the user enters an invalid date
    label_valid_date = FXLabel.new self, '', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_valid_date.x = @text_start_date.x - 2
    label_valid_date.y = @text_end_date.y + 35
    label_valid_date.backColor = FXColor::White
    label_valid_date.textColor = FXColor::Red

    # This label displays the text "Price Range"
    label_price = FXLabel.new self, 'Price Range', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_price.x = @checkbox_sold_out.x
    label_price.y = label_valid_date.y + 40
    label_price.backColor = FXColor::White
    label_price.textColor = FXColor::DarkRed
    label_price.font = FXFont.new app, 'Calibri,140,Medium'

    # This text field allows the user to enter in the starting date
    @text_min_price = FXTextField.new self, 15, opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    @text_min_price.x = label_price.x + 20
    @text_min_price.backColor = FXColor::LightGrey
    @text_min_price.y = label_price.y + 40
    @text_min_price.font = FXFont.new app, 'Calibri,100,Light'

    # This label displays the text "to" to specify a range of prices
    label_to_price = FXLabel.new self, 'to', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_to_price.x = label_to_date.x
    label_to_price.y = @text_min_price.y
    label_to_price.backColor = FXColor::White
    label_to_price.textColor = FXColor::Black

    # This text field allows the user to enter in the ending date
    @text_max_price = FXTextField.new self, 15, opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    @text_max_price.x = @text_end_date.x
    @text_max_price.backColor = FXColor::LightGrey
    @text_max_price.y = @text_min_price.y
    @text_max_price.font = FXFont.new app, 'Calibri,100,Light'

    # This label displays the text "Please enter a number." if the user enters an invalid price
    label_valid_price = FXLabel.new self, '', opts: LAYOUT_FIX_X|LAYOUT_FIX_Y
    label_valid_price.x = label_valid_date.x
    label_valid_price.y = @text_max_price.y + 35
    label_valid_price.backColor = FXColor::White
    label_valid_price.textColor = FXColor::Red

    # Button the user presses if they want to quit the filter dialog
    cancel_button = FXButton.new self, 'Cancel', target: self, selector: FXDialogBox::ID_CANCEL,
                                 opts: LAYOUT_FIX_X|LAYOUT_FIX_Y, padTop: 17, padBottom:17, padLeft: 35, padRight: 35
    cancel_button.x = @text_start_date.x + 10
    cancel_button.y = label_valid_price.y + 55

    # Button the user presses when they're finished entering in their name
    @filter_button = FXButton.new self, 'Filter', target: self, selector: FXDialogBox::ID_ACCEPT,
                 opts: LAYOUT_FIX_X|LAYOUT_FIX_Y, padTop: 17, padBottom:17, padLeft: 38, padRight: 38
    @filter_button.x = @text_end_date.x + 10
    @filter_button.y = cancel_button.y
    @filter_button.backColor = FXColor::DeepSkyBlue3
    @filter_button.textColor = FXColor::White

    @text_min_price.connect SEL_CHANGED do
      check_input_valid @text_min_price, label_valid_price, label_valid_date,'Please enter a number.', /\d+/
      check_input_logical_price label_valid_price, label_valid_date
    end

    @text_max_price.connect SEL_CHANGED do
      check_input_valid @text_max_price, label_valid_price, label_valid_date,'Please enter a number.', /\d+/
      check_input_logical_price label_valid_price, label_valid_date
    end

    @text_start_date.connect SEL_CHANGED do
      check_input_valid @text_start_date, label_valid_date, label_valid_price, 'Please enter a valid date (mm/dd/yyyy).', /\d\d?\/\d\d?\/\d\d\d\d/
      check_input_logical_date label_valid_date, label_valid_price
    end

    @text_end_date.connect SEL_CHANGED do
      check_input_valid @text_end_date, label_valid_date, label_valid_price, 'Please enter a valid date (mm/dd/yyyy).', /\d\d?\/\d\d?\/\d\d\d\d/
      check_input_logical_date label_valid_date, label_valid_price
    end

  end

  # Created 2/18/20 by Linda Wang
  # Checks the whether input is valid or not, and disables/enables the filter button and labels accordingly
  def check_input_valid(text_to_check, label_to_change, label_to_check, string_to_change_to, regex)
    if text_to_check.text.strip =~ regex || text_to_check.text.strip.empty?
      label_to_change.text = ''
      label_to_check.text.empty? ? @filter_button.enable : @filter_button.disable
    else
      label_to_change.text = string_to_change_to
      @filter_button.disable
    end
  end

  # Created 2/18/20 by Linda Wang
  # Checks whether the inputs for price make sense or not (i.e. if min_price < max_price) and updates filter button
  # and labels accordingly
  def check_input_logical_price(label_valid_price, label_valid_date)
    if !@text_min_price.text.empty? && !@text_max_price.text.empty? && label_valid_price.text.empty?
      if @text_max_price.text.strip.to_i < @text_min_price.text.strip.to_i
        label_valid_price.text = 'The min price must be smaller than the max price.'
        @filter_button.disable
      else
        label_valid_date.text.empty? ? @filter_button.enable : @filter_button.disable
      end
    end
  end

  # Created 2/18/20 by Linda Wang
  # Checks whether the inputs for date make sense or not (i.e. if end_date is after start_date) and updates filter button
  # and labels accordingly
  def check_input_logical_date(label_valid_date, label_valid_price)
    if !@text_start_date.text.empty? && !@text_end_date.text.empty? && label_valid_date.text.empty?
      start_date = DateTime.strptime(@text_start_date.text.strip, '%m/%d/%Y')
      end_date = DateTime.strptime(@text_start_date.text.strip, '%m/%d/%Y')
      if end_date > start_date
        label_valid_date.text = 'The start date must be before the end date.'
        @filter_button.disable
      else
        label_valid_price.text.empty? ? @filter_button.enable : @filter_button.disable
      end
    end
  end

  # Created 2/18/20 by Linda Wang
  # Returns the starting date the user typed
  def start_date
    @text_start_date.text
  end

  # Created 2/18/20 by Linda Wang
  # Returns the ending date the user typed
  def end_date
    @text_end_date.text
  end

  # Created 2/18/20 by Linda Wang
  # Returns the minimum price the user typed
  def min_price
    @text_min_price.text
  end

  # Created 2/18/20 by Linda Wang
  # Returns the maximum price the user typed
  def max_price
    @text_max_price.text
  end

  # Created 2/18/20 by Linda Wang
  # Returns whether or not the user selected the "display sold out events" checkbox or not
  def sold_out_events
    @checkbox_sold_out.checked?
  end

  # Created 2/18/20 by Linda Wang
  # Returns the types of events the user wanted to see
  def event_types
    event_types = []
    categories = %w[special sports arts concerts]
    @array_checkbox_event_types.each_with_index {|checkbox, index| event_types << categories[index] if checkbox.checked?}
    event_types
  end

  # Created 2/4/20 by Linda Wang
  # Shows the window
  def create
    super
    show PLACEMENT_SCREEN
  end


end

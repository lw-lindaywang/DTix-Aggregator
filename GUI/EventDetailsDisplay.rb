# Created 2/19/20 by Linda Wang

class EventDetailsDisplay < FXMainWindow

  # Created 2/19/20 by Linda Wang
  def initialize app, event

    # Initializes the window using inherited constructor
    super app, 'Event Details', width: 400, height: 450, padTop: 25

    # Sets background color to white
    self.backColor = FXColor::White

    details_matrix = FXMatrix.new self, opts: LAYOUT_CENTER_X|LAYOUT_CENTER_Y|LAYOUT_FILL|MATRIX_BY_COLUMNS, padLeft:30
    details_matrix.numColumns = 2

    details_matrix.backColor = FXColor::White

    detail_title = FXLabel.new details_matrix, 'Date', opts: JUSTIFY_CENTER_X, padLeft:0, padRight:50, padTop:5, padBottom: 5

    if event.key? :start_date
      detail_value = FXLabel.new details_matrix, event[:start_date].to_date.to_s + ' - ' + event[:end_date].to_date.to_s, opts: JUSTIFY_CENTER_X, padTop: 5, padBottom: 5, padLeft: 10
    else
      detail_value = FXLabel.new details_matrix, event[:event_date].to_date.to_s, opts: JUSTIFY_CENTER_X, padTop: 5, padBottom: 5, padLeft: 10
    end

    detail_title.backColor = FXColor::White
    detail_value.backColor = FXColor::White

    symbols = %i[title time description availability price sold_out]

    symbols.each do |symbol|
      next unless event.key? symbol
      detail_title = FXLabel.new details_matrix, symbol.to_s.capitalize, opts: JUSTIFY_CENTER_X, padLeft:0, padRight:50, padTop:5, padBottom: 5

      if symbol == :description
        text = FXText.new details_matrix, opts: VSCROLLER_NEVER|TEXT_WORDWRAP|TEXT_READONLY|LAYOUT_FILL_X|LAYOUT_FILL_Y, padLeft: 10, padRight:20
        text.text = event[:description]
        text.backColor = FXColor::White
        text.visibleRows = 10
      else
        detail_value = FXLabel.new details_matrix, event[symbol].to_s, opts: JUSTIFY_CENTER_X, padTop: 5, padBottom: 5, padLeft: 10
      end

      detail_title.backColor = FXColor::White
      detail_value.backColor = FXColor::White
    end

    init_external_link event[:external_link] if event.key? :external_link

  end

  def init_external_link link

    link_button = FXButton.new self, 'Go to Website', target: self, selector: FXDialogBox::ID_ACCEPT,
                                  opts: LAYOUT_CENTER_X|LAYOUT_FIX_Y, padTop: 17, padBottom:17, padLeft: 10, padRight: 10
    link_button.y = self.height - 100
    link_button.backColor = FXColor::DeepSkyBlue3
    link_button.textColor = FXColor::White

    link_button.connect SEL_COMMAND do
      open_external_site link
    end

  end

  # Created 2/18/2020 by Jeff Valli
  # Edited 2/19/2020 by Sai Chatla: Added method contract
  # Edited 2/19/2020 by Linda Wang: Updated for usage within the GUI
=begin
    Opens the external site for an event in firefox

    @param - external_links is the array of event sites
    @param - index is the index to the correct site
    @ensures - opens external site of event in browser
=end
  def open_external_site external_link
    system("firefox #{external_link} &")
  end

  # Created 2/19/20 by Linda Wang
  # Shows the window
  def create
    super
    show PLACEMENT_SCREEN
  end

end

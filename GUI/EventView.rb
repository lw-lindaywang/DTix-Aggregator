# Created 2/19/20 by Linda Wang

# Displays a card
class EventView < FXPacker

  attr_reader :event
  attr_accessor :selected, :event_image

  # Created 2/19/20 by Linda Wang
  def initialize(p, event, index)

    super p, opts: LAYOUT_CENTER_X|LAYOUT_CENTER_Y

    @event_image = FXImageFrame.new self, nil, 1, padTop: 5, padBottom:20, padLeft:20, padRight:20

    @event_image.backColor = FXColor::White
    self.backColor = FXColor::White

    @event = event

    @selected = false
    @index = index
    load_image

    text = FXText.new self, opts: VSCROLLER_NEVER|TEXT_WORDWRAP|TEXT_READONLY|LAYOUT_FILL_X|LAYOUT_FILL_Y, padLeft: 20, padRight:20
    text.text = @event[:title]
    text.backColor = FXColor::White
    text.visibleRows = 2

  end

  # Created 2/19/20 by Linda Wang
  # Used when loading the image upon initialization
  def load_image

    File.open "./Assets/#{@event[:type]}.PNG", 'rb' do |io|
      image = FXPNGImage.new app, io.read
      image.scale 170, 130, 1
      image.create
      @event_image.image = image
    end

  end

  # Created 2/19/20 by Linda Wang
  # If an image is selected, it fades to white. If it gets unselected, the original image gets loaded up again.
  def select_image
    File.open "./Assets/#{@event[:type]}.PNG", 'rb' do |io|
      image = FXPNGImage.new app, io.read
      image.scale 170, 130, 1
      image.fade FXColor::White, 50 if @selected
      image.create
      @event_image.image = image
    end
  end

end

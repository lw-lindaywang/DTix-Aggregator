# Created 2/19/20 by Linda Wang

# Dialog box that opens up for the user to input their name when saving a high score
class GetEmailDisplay < FXDialogBox

  # Created 2/4/20 by Linda Wang
  # Initializes and creates GUI elements for this window
  def initialize app

    # Uses the FXDialogBox constructor to initalize itself
    super app, 'Enter Your Email', height: 260, width: 220

    # Sets background color to white
    self.backColor = FXColor::White

    # This label displays the text "What is your email?"
    label_email = FXLabel.new self, "What is your email?", opts: LAYOUT_CENTER_X|LAYOUT_FIX_Y
    label_email.y = 20
    label_email.backColor = FXColor::White

    # This text field allows the user to enter in their email
    @text_email = FXTextField.new self, 22, opts: LAYOUT_CENTER_X|LAYOUT_FIX_Y
    @text_email.x = label_email.x
    @text_email.width = 200
    @text_email.backColor = FXColor::LightGrey
    @text_email.y = label_email.y + 40

    # This label displays the text "Enter a valid email." if the user enters an invalid price
    label_valid_email = FXLabel.new self, '', opts: LAYOUT_CENTER_X|LAYOUT_FIX_Y
    label_valid_email.y = @text_email.y + 35
    label_valid_email.backColor = FXColor::White
    label_valid_email.textColor = FXColor::Red

    # Button the user presses when they're finished entering in their email
    ok_button = FXButton.new self, "OK", target: self, selector: FXDialogBox::ID_ACCEPT,
                             opts: LAYOUT_CENTER_X|LAYOUT_FIX_Y, padTop: 10, padBottom:10, padLeft: 45, padRight: 45
    ok_button.y = @text_email.y + 80
    ok_button.backColor = FXColor::DeepSkyBlue3
    ok_button.textColor = FXColor::White

    # Button the user presses to quit the email dialog
    cancel_button = FXButton.new self, 'Cancel', target: self, selector: FXDialogBox::ID_CANCEL,
                                 opts: LAYOUT_CENTER_X|LAYOUT_FIX_Y, padTop: 10, padBottom:10, padLeft: 33, padRight: 33
    cancel_button.y = ok_button.y + 50

    @text_email.connect SEL_CHANGED do
      if @text_email.text =~ /[a-zA-Z.#\d]*@[a-z\d]*\.[a-zA-Z]*/
        label_valid_email.text = ''
        ok_button.enable
      else
        label_valid_email.text = 'Enter a valid email.'
        ok_button.disable
      end
    end

  end

  # Created 2/4/20 by Linda Wang
  # Returns a string representation of the text the user entered in as their name
  def to_s
    @text_email.text
  end

  # Created 2/4/20 by Linda Wang
  # Shows the window
  def create
    super
    show PLACEMENT_SCREEN
  end


end

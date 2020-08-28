# DTix Aggregator

### What is this?

A program that web scrapes all of the DTix (discounted tickets prices) events for OSU students and displays them in a user-friendly UI. Users can quickly and easily view event details, pricing, etc. and select events to export as a calendar file.

### Dependencies
To run this program, you will need FXRuby (https://github.com/larskanis/fxruby, http://index-of.es/Ruby/FXRuby%20-%20Create%20Lean%20and%20Mean%20GUIs%20with%20Ruby%20(2008).pdf) and Mail to run the program.  Also, need RSpec (https://rspec.info/) to run the test cases.

To install FXRuby, run the following commands from the project directory:
```
sudo apt-get install g++ libxrandr-dev libfox-1.6-dev
gem install fxruby
```
To install Mail, run the following commands from the project directory:
```
gem install mail
```
To install RSpec, run the following commands from the project directory:
```
gem install rspec
```
To ensure all dependencies are installed, run the following commands from the project directory:
```
bundle install
```

### Run Instructions
To run the program, go to the root directory and run:
```
ruby GUI/Driver.rb
```

### Testing
To run the test cases, be in the root directory of the project and run one at a time:
```
rspec testing/calendar_rspec.rb
rspec testing/scrape_rpsec.rb
```
Also, please make sure to go to the testing folder and check out system_testing_log.txt for system testing.

### Instructions
Upon launching, the GUI will display all the DTix events. If you left click on an event, it will turn white, indicating that it has been selected. If you click it again, that unselects the event. Selected events can be sent to a .ics file and emailed to yourself. To do so, go to the toolbar and go to File > Send Events to Calendar. Enter your email and an email with the attached .ics file will be sent to that email.

To use the .ics file, we recommend using Google Calendar. Go to calendar.google.com, and click the Gear icon in the top right corner. Then, click settings, and click "Import and Export" under "General" on the left. Upload the .ics file to the calendar, and the event will have been added.

If you right click an event, it will open details associated with that event. If the Dtix website linked to an external site, the button to launch that website will also be displayed.

You can also filter events based on event type, date, price, and whether or not they're sold out. To do so, go to File > Filter, which will open the filter dialog. By default, all events from Dtix are displayed. However, if you press Filter while leaving the "sold out" events checkbox unselected, it will remove them.

If you do not select any event types, it will not filter on event type. If you do not specify a price or a date range, it will not filter on those either.

For price and date range, you can specify both a minimum/maximum, or just one. Prices and date ranges are inclusive.

# File Created 2/18/2020 by Priya Perali
# Edited 2/19/2020 by Priya Perali: added test cases for write file

# Test cases for the calendar class
require 'rspec' 
require_relative '../source/calendar.rb'

# Created 2/18/2020 by Priya Perali
# Edited 2/19/2020 by Priya Perali: refactored code
describe "write events 1" do
  it "writes the events to icalendar file" do
    events = [['1/23/12','1:00 am','This is the summary','This is the description']]
    Calendar.write_file events 
    expect(File.size('./Files/calendar.ics')). to eql(222)
  end
end

# Created 2/19/2020 by Priya Perali 
describe "write events 2" do
  it "writes the events to the icalendar file" do
    events = []
    Calendar.write_file events
    expect(File.size('./Files/calendar.ics')). to eql(111)
  end
end

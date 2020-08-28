# File Created 2/18/2020 by Priya Perali
# Edited 2/18/2020 by Priya Perali: moved calendar functionality to different class
# Edited 2/18/2020 by Sai Chatla: Added functionality to email client .ics file to add to google calendar
# Edited 2/19/2020 by Sai Chatla: Added method contracts

require 'mail'

# Generates a icalendar file and send an email to the user with the file.

class Calendar
  
  # Created 2/18/2020 by Sai Chatla
  # Edited 2/18/2020 by Sai Chatla: Added functionality to email client .ics file to add to google calendar
=begin    
    Emails .ics file to user

    @param - email_address is the email of the client
    @ensures - email sent to the client with .ics file attached
=end
  def self.email_user email_address  

    # Establishes the sender's date
    options = { :address              => "smtp.gmail.com",
          :port                 => 587,
          :user_name            => 'rubythursday3901',
          :password             => 'rubySucks123',
          :authentication       => 'plain',
          :enable_starttls_auto => true  }

    Mail.defaults do
      delivery_method :smtp, options
    end
    
    # Constructs and delivers the email along with the .ics file
    Mail.deliver do
         to email_address
         from 'rubythursday3901@gmail.com'
         subject 'DTix Event Listing'
         body 'Hi, attached to this email is a .ics file with all the DTix Events that can be added to your google calendar!'
         add_file './Files/calendar.ics'
    end
  end
  
  # Created 2/16/2020 by Priya Perali
  # Edited 2/18/2020 by Priya Perali: Edited formating of the file
  # Edited 2/19/2020 by Sai Chatla: Added method contracts 
  # Edited 2/19/2020 by Linda Wang: Refactored to use updated data structure for events (array -> hash)
=begin    
    Writes multiple events to an .ics file

    @param - calendar is the file writer
    @param - events is the 2D array of event information
    @ensures - events are added to .ics file
=end
  def self.write_event calendar, events

    # Writes each event to the file
    events.each do |event|
      calendar.puts "BEGIN:VEVENT"

      event.key?(:start_date) ? (date = event[:start_date]) : (date = event[:event_date])

      day = date.day
      day = "0#{day}" if day.to_s.length == 1

      month = date.month
      month = "0#{month}" if month.to_s.length == 1

      # Write the title of the event to the file
      calendar.puts "SUMMARY:#{event[:title]}"
      # write the details of the event to the file
      calendar.puts "DESCRIPTION:#{event[:description]}"

      if event.key? :time
        hours = event[:time].split(':')[0]
        minutes = event[:time].split(' ')[0].split(':')[1]
        am_or_pm = event[:time].split(' ')[1]

        hours = (hours.to_i + 12).to_s if am_or_pm == 'PM'
        hours = "0#{hours}" if hours.length == 1

        # write the date/time to the file
        calendar.puts "DTSTART:#{date.year}#{month}#{day}T#{hours}#{minutes}00Z"
      else
        # write the all day event to the file
        calendar.puts "DTSTART;VALUE=DATE:#{date.year}#{month}#{day}"
      end

      calendar.puts "END:VEVENT"

    end
  end

        # Created 2/16/2020 by Priya Perali
        # Edited 2/18/2020 by Priya Perali: Edited formating of the file
  # Edited 2/19/2020 by Sai Chatla: Added method contracts
=begin    
    Writes calendar information to the .ics file

    @param - events is the 2D array of event information
    @ensures - properly formatted .ics file
=end

  def self.write_file events
    # Creates the .ics file or overwrites exisiting
    calendar = File.new('./Files/calendar.ics', 'w')

    # Write the header information for the calendar to the file
    calendar.puts "BEGIN:VCALENDAR"
    calendar.puts "PRODID:-Ruby Thursdays Calendar"
    calendar.puts "VERSION:2.0"
    calendar.puts "CALSCALE:GREGORIAN"
    calendar.puts "X-WR-TIMEZONE:UTC"
    
    # Write each event to the file
    write_event calendar, events

    # Write the footer information for calendar to the file
    calendar.puts "END:VCALENDAR"
    calendar.close
  end
end

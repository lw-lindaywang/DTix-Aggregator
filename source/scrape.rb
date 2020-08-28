# File created 2/11/2020 by Sai Chatla
# Edited 2/11/2020 by Sai Chatla: Developed way to parse dtix information into a 2d array
# Edited 2/12/2020 by Priya Perali: Added way to access multiple pages
# Edited 2/12/2020 by Sai Chatla: Streamlined methods and added more documentation
# Edited 2/13/2020 by Anish Anand: Added way to get price from a page
# Edited 2/13/2020 by Linda Wang: Added filtering for date and price
# Edited 2/13/2020 by Anish Anand: Edited price method to fix bugs
# Edited 2/13/2020 by Jeff Valli: Added function to get lottery times
# Edited 2/14/2020 by Jeff Valli: Made function to get all extra data together and from every page
# Edited 2/16/2020 by Priya Perali: Added icalendar functionality
# Edited 2/18/2020 by Priya Perali: Fixed formating of .ics file
# Edited 2/18/2020 by Anish Anand: Added event sales status functionality
# Edited 2/18/2020 by Jeff Valli: Changed event parse function to accept multiple arrays
# Edited 2/19/2020 by Sai Chatla: Added method contracts
# Edited 2/19/2020 by Linda Wang: Updated how the command line works in terms of running the program
# Edited 2/19/2020 by Priya Perali: Added image link functionality
# Edited 2/19/2020 by Priya Perali: Added documentation
# Edited 2/19/2020 by Linda Wang: Added implementation of hash array for events

require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'date'
require_relative 'calendar.rb'

# Parses the events from the dtix web page and stores them into a map for the user to filter through. Filters through the different events based on requirements given by the user.

class EventParse

  # Holds all the events from all the pages
	@@events = []

# Created 2/11/2020 by Sai Chatla
# Edited 2/11/2020 by Sai Chatla: Developed way to parse dtix information into a 2d array
# Edited 2/12/2020 by Sai Chatla: Got rid of lines with /
# Edited 2/13/2020 by Linda Wang: Added ability to parse with date
# Edited 2/16/2020 by Priya Perali: Added ability to create and write events to a calendar
# Edited 2/18/2020 by Jeff Valli: Changed function to accept arrays to store data in
# Edited 2/19/2020 by Jeff Valli: Added link to event on dtix for each event and removed event_in_range
# Edited 2/19/2020 by Jeff Valli: Fix broken price range code
# Edited 2/20/2020 by Linda Wang: Refactored. Changed event to a hash instead of an array, simplified logic
=begin
    Scapes dtix events

    @param - site is the url of the dtix event page
    @param - agent is the instance of the mechanize object
    @param - start_date is the DateTime object of the starting date to parse from
    @param - end_date is the DateTime object of the ending date to parse from
    @param - max_price represents the maximum price, if > max_price then don't display it
    @ensures - 2D array of text regarding dtix events
=end
 def self.event_parse(agent, page)

   # locates the events within the given page
   agent.get page
		 links = agent.page.links

		 links.map do |link|
      next unless link.uri.to_s.include?('/programs/dtix/events/?eventId=')
      next unless link.text != "\r\n"

      # Assign the map with the keys and value based on their identity
      event = {}
      link.to_s.each_line.with_index do |line, index|
				next unless line.strip != '' && line.strip != '/'
                                # Assigns the Date-Date attributes with the event start and end date
				if line.strip =~ %r{\d\d?/\d\d?/\d\d\d\d - \d\d?/\d\d?/\d\d\d\d}
					start_date_event = DateTime.strptime((line.strip.split '-')[0], '%m/%d/%Y')
					end_date_event = DateTime.strptime((line.strip.split '-')[1].strip, '%m/%d/%Y')
					event[:start_date] = start_date_event
					event[:end_date] = end_date_event
                                # Assigns the Date attribute the event date
				elsif line.strip =~ %r{\d\d?/\d\d?/\d\d\d\d}
					event_date = DateTime.strptime(line.strip, '%m/%d/%Y')
					event[:event_date] = event_date
                                # Assigns the Time attribute the event time
				elsif line.strip =~ /\d?\d:\d\d\s(a|A|p|P)(m|M)/
					event[:time] = line.strip
                                # Assign the title attribute with the event title
				elsif index == 12
					event[:title] = line.strip
                                # Assigns the describition attribute with the event details
				elsif line.strip =~ /[.!?]/
					event[:description] = line.strip
				end
      end
      # Assign the link with the event link
      event[:dtix_link] = "https://activities.osu.edu#{link.uri.to_s}"
 			  @@events << event
    end
 end

# Created 2/13/2020 by Linda Wang
=begin
    Checks if check_date is within a date range provided by start_date and end_date (inclusive)

    @param - check_date is the DateTime object to check of whether or not it's within the range
    @param - start_date is the DateTime object of the beginning of the date range
    @param - end_date is the DateTime object of the end of the date range
    @ensures - a boolean of if check_date is within the date range
=end
 def self.is_within_date_range(check_date, start_date, end_date)

   check_date == start_date || check_date == end_date || (check_date.between? start_date, end_date)

 end

	# Created 2/19/2020 by Priya Perali
	# Finds all the images
	def self.get_image_ref(agent, page, images)

                # locates img tags
		page.search('img').each do |image|
                        # ignores non-event image tags
			if image['src'].to_s != '/img/logo-sl.png'
                                # based on image, gives event type
				if image['src'].to_s.include? 'concerts'
					images << 'concerts'
				elsif image['src'].to_s.include? 'sports'
					images << 'sports'
				elsif image['src'].to_s.include? 'arts'
					images << 'arts'
				else
					images << 'special'
				end
			end
		end
		images
	end

# Created 2/12/2020 by Priya Perali
# Edited 2/12/2020 by Priya Perali: Navigates through the pages
# Edited 2/12/2020 by Sai Chatla: Made arrays concatenate into one array and added documentation
# Edited 2/13/2020 by Linda Wang: Date and price params added and implemented
# Edited 2/18/2020 by Jeff Valli: Changed function to accept multiple arrays to fill with data
# Edited 2/19/2020 by Jeff Valli: Changed call to get_indepth to after all events parsed and stored all data in event array
=begin
    Scrapes all dtix event pages

    @param - agent is the instance of the mechanize object
    @param - start_date is the DateTime object of the starting date to parse from
    @param - end_date is the DateTime object of the ending date to parse from
    @param - max_price represents the maximum price, if > max_price then don't display it
    @ensures - 2D array of text regarding dtix events on all pages
=end
 def self.multiple_pages agent
   images = []
   page = agent.get 'https://activities.osu.edu/programs/dtix/events/?page=0'
   event_parse agent, page

   get_image_ref agent, page, images

   while link1 = page.link_with(:text => 'Next »')
     # parses each page it encounters
     page = link1.click
     get_image_ref agent, page, images
     event_parse agent, page
   end

   # get in depth details about the event
   get_indepth @@events

   @@events.each_with_index do |event, index|
     event[:type] =  images[index]
   end

	end

# Created 2/15/2020 by Jeff Valli & Anish Anand
# Edited 2/18/2020 by Sai Chatla: Added method contract
# Edited 2/19/2020 by Jeff Valli: Updated to pass events and add extra data to each event array
# Edited 2/19/2020 by Anish Anand: Updated to pass sales status to event hash
# Edited 2/19/2020 by Jeff Valli: Updated string getters for indepth details
=begin
    Gets indepth event details

    @param - agent is the instance of the mechanize object
    @param - page is specific page of events on the dtix site
    @param - date is the event dates
    @param - prices is the price of the events
    @param - external_links is the event site
    @ensures - all available data on an event is trurned
=end
 def self.get_indepth events

   events.each do |event|
     next unless event[:dtix_link]
     noko_page = Nokogiri::HTML(open(event[:dtix_link].to_s))
     event[:availability] =  (noko_page.search("div.c-form__field")[1].to_s.split('<div class="c-form__field">').last.split('</div>')[0].strip)
     event.delete :availability if event[:availability].nil?
     event[:price] = (noko_page.search("div.c-form__field")[3].to_s.gsub('<div class="c-form__field">', '').gsub('$', '').gsub('</div>', '').strip.to_f).to_s.to_f
     event.delete :price if event[:price].nil?
     event[:external_link] = (noko_page.search("div.c-form__field")[5].to_s.split('href="').last&.split('">')&.first)
     event.delete :external_link if event[:external_link].nil?
     event[:sold_out] = sales_status noko_page
   end
 end

# Created 2/18/2020 by Anish Anand
# Edited 2/19/2020 by Anish Anand: Removed iterations parts of method to add to indepth events method
=begin
    Displays if the events on a page are sold out or not

    @param - event is the link of an event
    @ensures - a string is returned that states whether the event is sold out or not
=end
  def self.sales_status page
   sold_out = ''
     sellInfoString = page.search("div.c-form__field")[4].to_s.gsub('<div class="c-form__field">', '').gsub('\n', '').gsub('<p>&nbsp;</p>', '').gsub('<p>', '').gsub('</p>','').strip
     if sellInfoString.include? 'sold out'
      sold_out = 'Sold out'
     else
      sold_out = 'Still open'
     end
    sold_out
  end

#Edited 2/19/2020 by Jeff Valli: Fixed price bug
  def self.filter(start_date, end_date, min_price, max_price, sold_out, event_types)

    filter_events = []

    @@events.each do |event|

      if event.key? :start_date
        if !start_date.nil? && !end_date.nil?
          next unless is_within_date_range start_date, event[:start_date], event[:end_date] or
              is_within_date_range end_date, event[:start_date], event[:end_date] or
              is_within_date_range event[:start_date], start_date, end_date or
              is_within_date_range event[:end_date], start_date, end_date
        elsif start_date.nil? && !end_date.nil?
          next unless event[:start_date] <= end_date
        elsif end_date.nil? && !start_date.nil?
          next unless event[:end_date] >= start_date
        end
      else
        if !start_date.nil? && !end_date.nil?
          next unless is_within_date_range event[:event_date], start_date, end_date
        elsif start_date.nil? && !end_date.nil?
          next unless event[:event_date] <= end_date
        elsif end_date.nil? && !start_date.nil?
          next unless event[:event_date] >= start_date
        end
      end

      if event.key? :price
        if !min_price.nil? && !max_price.nil?
          next unless event[:price].to_f >= min_price && event[:price].to_f <= max_price
        elsif min_price.nil? && !max_price.nil?
          next unless event[:price] <= max_price
        elsif max_price.nil? && !min_price.nil?
          next unless event[:price] >= min_price
        end
      end

      # if sold_out is true that means the user wants to see sold out events
      if event.key? :sold_out
        next if event[:sold_out] == 'Sold out' && !sold_out
      end

      if !event_types.empty? && event.key?(:type)
        next unless event_types.include? event[:type]
      end

      filter_events << event
    end

    filter_events
  end
end

# Created 2/12/2020 by Sai Chatla
# Edited 2/12/2020 by Sai Chatla: Filled body
# Edited 2/13/2020 by Linda Wang: Added options to filter date and price
# Edited 2/13/2020 by Anish Anand: Added print cases for getting price
if __FILE__ == $PROGRAM_NAME

	start_date, end_date, max_price = *nil

        # Determines whether the program should filter the initail results from parsing through the page
	print 'Would you like events in just a certain date range? (Y|N): '

	if gets.chomp == 'Y'
    print 'Enter the starting date (mm/dd/yyyy): '
    start_date = DateTime.strptime(gets.chomp, '%m/%d/%Y')
    print 'Enter the ending date (mm/dd/yyyy): '
    end_date = DateTime.strptime(gets.chomp, '%m/%d/%Y')
  end

	print 'Would you like events in just a certain price range? (Y|N): '

	if gets.chomp == 'Y'
		print 'Enter the minimum price: '
		min_price = gets.chomp!
		print 'Enter the maximum price: '
		max_price = gets.chomp!
	end

	agent = Mechanize.new
	EventParse.multiple_pages agent
	pp EventParse.filter(start_date, end_date, min_price, max_price, false, [0, 0, 0, 0])
end


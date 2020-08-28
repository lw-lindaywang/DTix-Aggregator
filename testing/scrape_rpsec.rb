# File created 2/18/2020 by Priya Perali
# Edited 2/19/2020 by Priya Perali: added test cases for the date range method

# Test cases for the scrape class

require 'rspec'
require_relative '../source/scrape.rb'

# Created 2/19/2020 by Priya Perali
describe "checks date range 1" do
  it "checks whether the date is within the given date range" do
    check_date = '2/20/2020'
    start_date = '2/19/2020'
    end_date = '2/21/2020'
    expect(EventParse.is_within_date_range(check_date, start_date, end_date)). to eql(true)
  end
end

# Created 2/19/2020 by Priya Perali
describe "checks date range 2" do
  it "checks whether the date is within the given date range" do
    check_date = '2/20/2020'
    start_date = '2/20/2020'
    end_date = '2/21/2020'
    expect(EventParse.is_within_date_range(check_date, start_date, end_date)). to eql(true)
  end
end

# Created 2/19/2020 by Priya Perali
describe "checks date range 3" do
  it "checks whether the date is within the given date range" do
    check_date = '2/19/2020'
    end_date = '2/19/2020'
    start_date = '2/18/2020'
    expect(EventParse.is_within_date_range(check_date, start_date, end_date)). to eql(true)
  end
end

# Created 2/19/2020 by Priya Perali
describe "checks date range 4" do
  it "checks whether the date is within the given date range" do
  check_date = '2/18/2020'
  end_date = '2/17/2020'
  start_date = '2/16/2020'
  expect(EventParse.is_within_date_range(check_date, start_date, end_date)). to eql(false)
  end
end

# Created 2/19/2020 by Priya Perali
describe "checks date range 5" do
  it "checks whether the date is within the given date range" do
    check_date = '2/18/2020'
    end_date = '2/20/2020'
    start_date = '2/19/2020'
    expect(EventParse.is_within_date_range(check_date, start_date, end_date)). to eql(false)
  end
end

# Created 2/19/2020 by Priya Perali
describe "checks date range 6" do
  it "checks whether the date is within the given date range" do
    check_date = '2/18/2020'
    end_date = '2/17/2020'
    start_date = '2/19/2020'
    expect(EventParse.is_within_date_range(check_date, start_date, end_date)).to eql(false)
  end
end

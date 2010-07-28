require 'test_helper'
require 'chronic'

class SirTest < ActiveSupport::TestCase

  test "parse_incident_datetime" do
    sir = Sir.create(:incident_datetime_string => "yesterday 10am")
    assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir.incident_datetime
    sir = Sir.new(:incident_datetime_string => "yesterday 10am")
    assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir.incident_datetime
  end

  test "error_on_bad_incident_datetime_parse" do
    sir = Sir.create(:incident_datetime_string => "10am yesterday")
    assert_equal "Sorry, couldn't parse Incident Time. Please try again, eg 'July 10, 3:40pm'", sir.errors.on(:base)
    sir = Sir.new(:incident_datetime_string => "10am yesterday")
    sir.save
    assert_equal "Sorry, couldn't parse Incident Time. Please try again, eg 'July 10, 3:40pm'", sir.errors.on(:base)
  end
  
  test "error_on_future_incident_datetime" do
    sir = Sir.create(:incident_datetime_string => "tomorrow 10pm")
    assert_equal "Incident Time must be in the past", sir.errors.on(:base)
    sir = Sir.new(:incident_datetime_string => "tomorrow 10pm")
    sir.save
    assert_equal "Incident Time must be in the past", sir.errors.on(:base)
  end

  fields = [:incident_datetime_string, :der_time_in_string, :der_time_door_string, :der_time_out_string]
  field_out = {:incident_datetime_string => :incident_datetime, :der_time_in_string => :der_time_in, :der_time_door_string => :der_time_door, :der_time_out_string => :der_time_out}
  field_display = {:incident_datetime_string => "Incident Time", :der_time_in_string => "DER Time In", :der_time_door_string => "DER Time Door", :der_time_out_string => "DER Time Out"}
  
  test "parse" do
    for field in fields
      sir = Sir.create(field => "yesterday 10am")
      assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir.send(field_out[field])
      sir = Sir.new(field => "yesterday 10am")
      assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir.send(field_out[field])
    end
  end
  
  test "error_on_bad_parse" do
    for field in fields
      sir = Sir.create(field => "10am yesterday")
      assert_equal "Sorry, couldn't parse #{field_display[field]}. Please try again, eg 'July 10, 3:40pm'", sir.errors.on(:base)
    end
  end
  
  test "error_on_future_datetime" do
    for field in fields
      sir = Sir.create(field => "tomorrow 10pm")
      assert_equal "#{field_display[field]} must be in the past", sir.errors.on(:base)
    end
  end

  test "parse_on_update" do
    sir = Sir.create(:incident_datetime_string => "yesterday 10am")
    assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir.incident_datetime
    sir.update_attributes({:incident_datetime_string => "today 10am"})
    assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday, 10, 0, 0), sir.incident_datetime
  end
  
  test "save_and_recover" do
    sir = Sir.new(:incident_datetime_string => "yesterday 10am", :description => "testing!")
    sir.save
    assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir.incident_datetime
    sir2 = Sir.find(sir.id) # really the same one
    assert_equal "testing!", sir2.description
    assert_equal Time.local(Time.now.year, Time.now.month, Time.now.mday-1, 10, 0, 0), sir2.incident_datetime
  end

end

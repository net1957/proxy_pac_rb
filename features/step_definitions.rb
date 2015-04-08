Given(/^a proxy\.pac named "([^"]*)" does not exist$/) do |name|
  FileUtils.rm_rf absolute_path("#{name}.pac")
end

Then(/^the proxy\.pac "([^"]*)" should contain:$/) do |name, string|
  step %(the file "#{name}.pac" should contain:), string
end

Given(/^a proxy\.pac named "([^"]*)" with:$/) do |name, string|
  step %(a file named "#{name}.pac" with:), string
end

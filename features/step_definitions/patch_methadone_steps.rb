Then /^the following trollop options should be documented:$/ do |options|
  options.raw.each do |option|
    step %(the output should match /\\s*#{Regexp.escape(option.first)}\\s+\\w+\\w+\\w+/)
  end
end

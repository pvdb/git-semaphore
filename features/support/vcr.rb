require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock # or :fakeweb
  c.cassette_library_dir = 'features/cassettes'
  c.debug_logger = File.open('vcr_debug.log', 'w')
end

VCR.cucumber_tags do |t|
  t.tag '@vcr_api_projects'
  t.tag '@vcr_api_branches'
  t.tag '@vcr_api_status'
  t.tag '@vcr_api_rebuild_last_revision'
end

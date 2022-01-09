require 'logger'
require 'yaml'
require 'date'

class PostGenerator
  def initialize(src_path: nil)
    @logger = Logger.new(STDOUT)
    @src_path = src_path || '_data/events.yaml'
  end

  def call
    read_events
    generate_all
  end

  private

  def read_events
    # TODO: Validate events, catch error, must be an array
    @events = YAML.load_file(@src_path)
  end

  def generate_all
    @events.each do |event|
      generate_post_for(event)
    end
  end

  def generate_post_for(event)
    @logger.info("Handling #{event}")
    # TODO: supported keys
    # TODO: check if file already exists (override, option ?)

    date = parse_date(event)
    frontend_matter =
      file_name = "#{date}-#{event['title']}.markdown"

    File.open("_posts/#{file_name}", 'w') do |file|
      file.write(generate_frontendmatter(event, date).to_yaml)
      file.write("---\n")
      file.write(generate_body(event))
    end
  end

  def parse_date(event)
    Date.new(event['year'], event['month'], event['day'])
  rescue Date::Error
    raise EventYAMLError, 'Date is invalid'
  end

  def generate_frontendmatter(event, date)
    raise EventYAMLError, 'Missing title' unless event['title']

    {
      layout: event['layout'] || 'post',
      title: (event['title']).to_s,
      date: date.to_s,
      categories: event['categories'] || 'event'
    }
  end

  def generate_body(event)
    raise EventYAMLError, 'There must be at least 1 drama per event' if event['dramas'].size.zero?

    body = ''
    event['dramas'].each do |drama|
      if drama['source'].nil? && drama['link'].nil?
        raise EventYAMLError,
              'There must be a source and a link for each drama'
      end

      body << "- #{drama['description']} ─ [#{drama['source']}](#{drama['link']})\n"
    end

    body
  end

  class PostGeneratorError < StandardError; end

  class EventYAMLError < PostGeneratorError; end
end

PostGenerator.new.call

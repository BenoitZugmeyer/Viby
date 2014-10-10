# -*- coding: utf-8 -*-
require 'open-uri'

class Stack
  include Cinch::Plugin

  match(/stack\s*(\d*)$/i)

  def execute (m, index)
    url = config['redmine_url']
    doc = open(url,
         "X-Redmine-API-Key" => config['redmine_api_key'].to_s
        ).read
    text = JSON.parse(doc)['wiki_page']['text']
    name = text.scan(/\* \d{4}-\d{2}-\d{2}: (\S*)/)[index.to_i]
    if name
        name = name[0]
    end
    if config.key? 'aliases' and config['aliases'].key? name
        name = config['aliases'][name]
    end
    puts name
    m.reply "#{name}, it's your turn!"
  end
end

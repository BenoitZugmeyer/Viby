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
    matches = Hash[text.scan(/\* (\d{4}-\d{2}-\d{2}): (\S*)/)]
    now = Time.now.strftime '%Y-%m-%d'
    name = matches[now] || matches[matches.keys.first]
    if config.key? 'aliases' and config['aliases'].key? name
        name = config['aliases'][name]
    end
    m.reply "#{name}, it's your turn!"
  end
end

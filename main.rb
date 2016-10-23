require 'koala'
require_relative './config/secrets.rb'
require_relative './lib/markov.rb'

markov = Markov.new

texts = File.read('./samples/sample_1')
aphrase = File.read('./samples/sample_2')

markov.feed(texts)
markov.normalize!
post = markov.generate_phrase('A')
puts post

#api = Koala::Facebook::API.new(FB_APP_TOKEN)
#api.put_wall_post(post) 

require 'json'
class Markov
	
	TOKEN_SPLITTER = %r{\s+|(\,\s+)|(\.\s+|\.$)|(\?\s+|\?$)|(\!\s+|\!$)}.freeze
	SENTENCE_END = %r{\A[\.|\?|!]\z}.freeze
	attr_accessor :state	


	def initialize
		@state = {}
	end

	def feed(texts)
		tokens = texts.split(TOKEN_SPLITTER)
		push(tokens)
	end

	def generate_phrase(token)
		# Token is a string: " Hello " and needs to be stripped.
		token = token.strip
		key = [token]
		return '' unless @state[key] 
		buffer = [token]
		loop do
			
			break if key[0] =~ SENTENCE_END 
		
			word_hash = @state[key]
			random_number = rand()
			
			next_token = word_hash
				.select do |word, data|
					data[:lower] < random_number && data[:upper] >= random_number
				end.to_a[0][0]
		

			#next_token = .to_a.sample[0]
			buffer.push(next_token)
			key = [next_token]	
				
		end
		buffer.join(' ')	
		
	end

	def normalize!
		@state.each do |key, word_hash|
			result = word_hash.reduce(0) do |total, word_pair|
				# word_pair contains the next word and the occurences.
				total + word_pair[1][:occurence]
			end.to_f

			word_hash.each do |word, data|	
				data[:probability] = data[:occurence] / result
			end
			word_hash.reduce(0.0) do |total, word_pair| 
				data = word_pair[1]
				data[:lower] = total
				data[:upper] = total + data[:probability]
			end	
		end

	end

	private 
	
	def push(tokens)
		index = 0
		while index < tokens.size - 1
			current_token = tokens[index].strip
			next_token    = tokens[index + 1].strip
		
			# ["cuvant"] => {'urmatorul' => 2, 'altul' => 3}
			key = [current_token]


			if existing = @state[key]
				count = existing[next_token] || {occurence: 0}
				existing[next_token] = {occurence: count[:occurence] + 1}			
			else
				@state[key] = {next_token => {occurence: 1}}
			end
			
			index += 1
		end
			 	
			
	end

end

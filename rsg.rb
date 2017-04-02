=begin

  Author: Ismael DeLuna
  UID: U92754525

=end

# Extracts just the definitions from the grammar file
# Returns an array of strings where each string is the lines for
# a given definition (without the braces)
def read_grammar_defs(filename)
  puts 'Opening file ' + filename
  filename = 'grammars/' + filename unless filename.start_with? 'grammars/'
  filename += '.g' unless filename.end_with? '.g'
  contents = open(filename, 'r') { |f| f.read }
  contents.scan(/\{(.+?)\}/m).map do |rule_array|
    rule_array[0]
  end
end


#==========================================================================
#==========================================================================



# Takes data as returned by read_grammar_defs and reformats it
# in the form of an array with the first element being the
# non-terminal and the other elements being the productions for
# that non-terminal.
# Remember that a production can be empty (see third example)
# Example:
#   split_definition "\n<start>\nYou <adj> <name> . ;\nMay <curse> . ;\n"
#     returns ["<start>", "You <adj> <name> .", "May <curse> ."]
#   split_definition "\n<start>\nYou <adj> <name> . ;\n;\n"
#     returns ["<start>", "You <adj> <name> .", ""]
def split_definition(raw_def)
  # TODO: your implementation here

  #breaks down the non-terminal and the elements for the non-terminal
  raw_def = raw_def.map {|x| x.sub(/>/, '>;')}
  raw_def = raw_def.map{|x| x.strip}
  raw_def = raw_def.map{|x| x.split(/;/).flatten.map{|y| y.strip}}
  raw_def = raw_def.map{|x| x.map{|x| x.strip}}

end

#==========================================================================
#==========================================================================


# Takes an array of definitions where the definitions have been
# processed by split_definition and returns a Hash that
# is the grammar where the key values are the non-terminals
# for a rule and the values are arrays of arrays containing
# the productions (each production is a separate sub-array)

# Example:
# to_grammar_hash([["<start>", "The   <object>   <verb>   tonight."], ["<object>", "waves", "big    yellow       flowers", "slugs"], ["<verb>", "sigh <adverb>", "portend like <object>", "die <adverb>"], ["<adverb>", "warily", "grumpily"]])
# returns {"<start>"=>[["The", "<object>", "<verb>", "tonight."]], "<object>"=>[["waves"], ["big", "yellow", "flowers"], ["slugs"]], "<verb>"=>[["sigh", "<adverb>"], ["portend", "like", "<object>"], ["die", "<adverb>"]], "<adverb>"=>[["warily"], ["grumpily"]]}
def to_grammar_hash(split_def_array)
  # TODO: your implementation here
  gram = Hash.new
  #outputs as sample above, for arrays to be broken apart in the expansion
  split_def_array.map{|x| gram[x.shift] = x.map{|x| x.split(/\s+/)}}
  return gram

end

#==========================================================================
#==========================================================================

# Returns true iff s is a non-terminal
# a.k.a. a string where the first character is <
#        and the last character is >
def is_non_terminal?(s)
  # TODO: your implementation here
  /<[\w-]+>/.match(s)
  #------------------------------------------------------------------------
  #\w regular expression = Any word character(letter, number, underscore)
  #The brackets accept the range of the matching
  #The plus sign expands multiple words where the - allows hyphenations
  #like that of the Bond-movie file
  #------------------------------------------------------------------------
end

#==========================================================================
#==========================================================================

# Given a grammar hash (as returned by to_grammar_hash)
# returns a string that is a randomly generated sentence from
# that grammar
#
# Once the grammar is loaded up, begin with the <start> production and expand it to generate a
# random sentence.
# Note that the algorithm to traverse the data structure and
# return the terminals is extremely recursive.
#
# The grammar will always contain a <start> non-terminal to begin the
# expansion. It will not necessarily be the first definition in the file,
# but it will always be defined eventually. Your code can
# assume that the grammar files are syntactically correct
# (i.e. have a start definition, have the correct  punctuation and format
# as described above, don't have some sort of endless recursive cycle in the
# expansion, etc.). The names of non-terminals should be considered
# case-insensitively, <NOUN> matches <Noun> and <noun>, for example.
def expand(grammar, non_term="<start>")
  # TODO: your implementation here
  randomSentence = ''

  generator = grammar[non_term].sample
  #sample, to where it generates a random portion of the array
  if(generator.length > 0) and (generator.length != nil)
    #Checks to make sure each input is greater than 0 or not equal to nil
    generator.each {|x|
      #checks for non-terminal so that it may be expanded upon
    if (is_non_terminal?(x))
      randomSentence += expand(grammar, x)
    else
      #if not a non-terminal, pushes out the randomized x
      randomSentence += x + ' '
    end
    }
  end
  #returns strings for the print function to trinkle back upwards
  return randomSentence
end

#==========================================================================
#==========================================================================

# Given the name of a grammar file,
# read the grammar file and print a
# random expansion of the grammar
def rsg(filename)
  # TODO: your implementation here
  rawdef = read_grammar_defs(filename)
  spldef = split_definition(rawdef)
  gram = to_grammar_hash(spldef)
  expand(gram)
  #Calls each function independently so that there was no confusion when
  #writing each one

end

#==========================================================================
#==========================================================================



if __FILE__ == $PROGRAM_NAME
  # TODO: your implementation of the following
  # prompt the user for the name of a grammar file
  # rsg that file
  puts 'Enter a Filename'
  filename = gets.chomp
  print rsg(filename)

  #------------------------------------------------------------------------
  #Reads in users line, chomping off the last character of input
  #allowing it to be read-in, then call the method rsg on it before printing
  #------------------------------------------------------------------------
end


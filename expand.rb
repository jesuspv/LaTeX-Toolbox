#!/usr/bin/ruby

# Improvements:
# - check that bbl file exists
# - remove the path of the images (and icons!)
# - remove pdf graphicx related lines but for '\DeclareGraphicsExtensions{.pdf,.png}'

inputfilename  = ARGV[0]
outputfilename = ARGV[1]

if inputfilename.nil? or outputfilename.nil? or
  not File::exists?(inputfilename) or
  outputfilename == ""
then
  puts "Usage: expand.rb <inputfilename> <outputfilename>"
  exit
end

output = File.new(outputfilename,"w")

File.open(inputfilename,"r").each { |line|
  if line =~ /^\\input\{.*\}$/ then
    output.puts("%%%%% EXPANDED! " + line)
    file = line.strip.sub(/^\\input\{/, "").sub(/\}$/, ".tex")
    
    File.open(file,"r").each{ |fileline|
      output.puts fileline
    }
  elsif line =~ /.*\\bibliographystyle\{.*\}.*/ then
    output.puts("%%%%% EXPANDED! " + line)
  elsif line =~ /.*\\bibliography\{.*\}.*/ then
    output.puts("%%%%% EXPANDED! " + line)
    
    bblfilename = inputfilename.sub(/tex$/, "bbl")
    File.open(bblfilename).each { |line|
      output.puts line
    }
  else
    output.puts line
  end
}

output.close

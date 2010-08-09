require 'getoptlong'

class Number
  def initialize(num=1)
  	@reg = Array.new(num) {|i| 0}
  end

  arith = {}
  #Get custom shortkeys from config file
  File.open("shortkeys.txt") do |file|
	while content = file.gets
	  if (content =~ /(.*?):(.*)/)
	    arith[$1] = $2
	  end
	end
  end

  enter = 13.chr
  define_method enter do
    repeatChar = @reg.pop
    @reg.push(repeatChar)
    @reg.push(repeatChar)
    @reg
  end
  
  define_method arith["add"] do
    puts "Adding!"
    a = @reg.pop
    b = @reg.pop
    c = a + b
    #puts c
    @reg.push(c)
  end
  
  define_method arith["subtract"] do
    puts "Subtracting!"
    a = @reg.pop
    b = @reg.pop
    c = b - a
    #puts c
    @reg.push(c)
  end
  
  define_method arith["multiply"] do
    puts "Multiplying!"
    a = @reg.pop
    b = @reg.pop
    c = a*b
    #puts c
    @reg.push(c)
  end
  
  define_method arith["divide"] do
    puts "Dividing!"
    a = @reg.pop
    b = @reg.pop
    c = b/a
    #puts c
    @reg.push(c)
  end
  
  define_method arith["sine"] do
    puts "Computing sine!"
    a = @reg.pop
    c = Math.sin(a)
    #puts c
    @reg.push(c)
  end
     
  define_method arith["cosine"] do
    puts "Computing cosine!"
    a = @reg.pop
    c = Math.cos(a)
    #puts c
    @reg.push(c)
  end
  
  define_method arith["delete"] do 
    puts "Deleting last reg!"
    @reg.pop
  end
  
  define_method arith["print"] do
    regnum = 1
  	@reg.each do |reg|
  	   output = "Reg"+ regnum.to_s+ ":"+ reg.to_s+ "\n" 
  	   puts output
  	   regnum = regnum + 1
  	end
  end
  
  define_method arith["moveup"] do
    puts "Rotating!"
    a = @reg.pop
    @reg.unshift(a)
  end
  
  define_method arith["movedown"] do
    puts "Rotating!"
    a = @reg.shift
    @reg.push(a)
  end
  
  define_method arith["swapbottom"] do
    puts "Swapping bottom!"
    a = @reg.pop
    b = @reg.pop
    @reg.push(a)
    @reg.push(b)
  end
  
  define_method arith["swaptop"] do
    puts "Swapping top!"
    a = @reg.shift
    b = @reg.shift
    @reg.unshift(a)
    @reg.unshift(b)
  end
  
  def print
    puts @reg
  end
  
  def push(num)
    @reg.push(num)
  end
  
  define_method arith["quit"] do
    puts "Exiting..."
    exit(0)
  end
  
end

begin
  require "Win32API"
  def readChar
    Win32API.new("crtdll", "_getch", [], "L").Call
  end
rescue LoadError
  def readChar
    old = `stty -g`
    system "stty raw -echo"
    STDIN.getc
  ensure
    system "stty #{old}"
  end
end

def read__Char
  old = `stty -g`
  system "stty raw -echo"
  STDIN.getc
ensure
  system "stty #{old}"
end  

def main_loop (fast)
  calculations = []  # strings of calculations
  calculations[0] = Number.new
  index = 0
  loop do
  	if fast == 0
  		#"Safe Mode"
			input = []
			c = readChar
			input.push(c.chr)
    unless input[0] =~ /[0-9]/ or input[0] == ':' #skip if not a single char command
      #Handle exception if no method name
      begin
        calculations[index].send(input[0])
      rescue
        puts "No such method:"+input[0]
      end
    else 
      print c.chr
      string = gets.chomp #get entire string
      input = input + string.to_a
      #print input
      if input[0] == ':'
        calculations[index].send(input.to_s)
      else
	    	begin
	  	  	calculations[index].push(Float(input.to_s))
	  	  rescue
	  	  	puts "Not a valid number"
	  	  end
      end  
    end
    puts "----"
    calculations[index].print
  	else
  	  #"Fast Mode"
  	  input = []
  	  c = readChar
  	  input.push(c.chr)
	  	if input[0] == ':'
	  	  print ':'
	  	  string = gets.chomp
	  	  input = input + string.to_a
	  		calculations[index].send(input.to_s)
	  	else
  			unless input[0] =~ /[0-9]/ or input[0] == '.'
  				begin
		        calculations[index].send(input[0])
		      rescue
		        puts "No such method:"+input[0]
		      end
		    else 
		    	#puts "getting a number"
		    	print input[0]
		    	while 1
		    		#print "getting next int"
		    		c = readChar
		    		print c.chr
		    		unless c.chr =~ /[0-9]/ or c.chr == '.' 
		    		  #puts input.to_s
		    		  #puts "testing"
		    		  calculations[index].push(Float(input.to_s))
		    		  begin
		    		  	if c == 13 #Don't execute command if enter
		    		  	  break
		    		  	else
		        			calculations[index].send(c.chr.to_s)
		        		end
		      		rescue
		        		puts "No such method:"+c.chr.to_s
		      		end #input = input + c.chr
		    			break
		    		else
		    			#print c.chr	    			
		    			input.push(c.chr)
		    			#break
		    		end
		    		
		    	end
  	  	end 	 
	  	  #c = readChar
	  	  #exit if c.chr == 'q'
	  	  puts "----"
    		calculations[index].print
	  	end
  	end    	
  end    
end


if __FILE__ == $PROGRAM_NAME
  #puts ARGV[0]
  puts "Starting Calculator... \n"  
  #ARGV.pop
  opts = GetoptLong.new(
    [ '--fast', GetoptLong::OPTIONAL_ARGUMENT ]
  )
  fastmode = 0
  opts.each do |opt, arg|
		case opt
    	when '--fast'
      	fastmode = 1
    end
  end
  
  if fastmode == 1
    puts "Fast Mode"
  else
  	puts "Safe Mode"
  end	
  
  main_loop fastmode
end



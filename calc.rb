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
    #puts "Adding!"
    a = @reg.pop
    b = @reg.pop
    c = a + b
    puts c
    @reg.push(c)
  end
  
  define_method arith["subtract"] do
    #puts "Subtracting!"
    a = @reg.pop
    b = @reg.pop
    c = b - a
    puts c
    @reg.push(c)
  end
  
  define_method arith["multiply"] do
    #puts "Multiplying!"
    a = @reg.pop
    b = @reg.pop
    c = a*b
    puts c
    @reg.push(c)
  end
  
  define_method arith["divide"] do
    #puts "Dividing!"
    a = @reg.pop
    b = @reg.pop
    c = b/a
    puts c
    @reg.push(c)
  end
  
  define_method arith["sine"] do
    #puts "Computing sine!"
    a = @reg.pop
    c = Math.sin(a)
    puts c
    @reg.push(c)
  end
     
  define_method arith["cosine"] do
    #puts "Computing cosine!"
    a = @reg.pop
    c = Math.cos(a)
    puts c
    @reg.push(c)
  end
  
  define_method arith["undo"] do 
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

def main_loop
  calculations = []  # strings of calculations
  calculations[0] = Number.new
  index = 0
  loop do
    input = []
    c = readChar

    input.push(c.chr)
    unless input[0] =~ /[1-9]/ or input[0] == ':' #skip if not a single char command
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
        calculations[index].push(Float(input.to_s))
      end
    end
    puts "----"
    calculations[index].print
  end      
end


if __FILE__ == $PROGRAM_NAME
  #puts ARGV[0]
  puts "Starting Calculator... \n"
  #ARGV.pop
  main_loop
end



# toy_robot_simulator.rb
require 'byebug'
class ToyRobotSimulator
 attr_reader :captured_output



  def initialize(input_stream = $stdin, output_stream = $stdout)
    @x = nil
    @y = nil
    @facing = nil
    @input = input_stream
    @output = output_stream
    @captured_output = ''
  end

  # Other methods...

  def report
    @captured_output = "Current position: #{@x}, #{@y}, #{@facing}"
    @output.puts @captured_output
  end

  def run_simulation(commands)
    commands.each do |command|
      case command[0]
      when 'PLACE'
        place(command[1].to_i, command[2].to_i, command[3])
      when 'MOVE'
        move
      when 'LEFT'
        left
      when 'RIGHT'
        right
      when 'REPORT'
        report
      end
    end
  end

  def place(x, y, facing)
    if valid_position?(x, y) && valid_facing?(facing)
      @x, @y, @facing = x, y, facing
    else
      @output.puts "Invalid PLACE command. Ignoring."
    end
  end

  def move
    case @facing
    when 'NORTH'
      @y += 1 if valid_position?(@x, @y + 1)
    when 'SOUTH'
      @y -= 1 if valid_position?(@x, @y - 1)
    when 'EAST'
      @x += 1 if valid_position?(@x + 1, @y)
    when 'WEST'
      @x -= 1 if valid_position?(@x - 1, @y)
    end
  end

  def left
    @facing = case @facing
               when 'NORTH' then 'WEST'
               when 'SOUTH' then 'EAST'
               when 'EAST'  then 'NORTH'
               when 'WEST'  then 'SOUTH'
               end
  end

  def right
    @facing = case @facing
               when 'NORTH' then 'EAST'
               when 'SOUTH' then 'WEST'
               when 'EAST'  then 'SOUTH'
               when 'WEST'  then 'NORTH'
               end
  end

  def report
    capture_output("Current position: #{@x}, #{@y}, #{@facing}")
    @captured_output
  end

  private

  def valid_position?(x, y)
    (0..4).cover?(x) && (0..4).cover?(y)
  end

  def valid_facing?(facing)
    ['NORTH', 'SOUTH', 'EAST', 'WEST'].include?(facing)
  end

   def capture_output(message)
    @captured_output = message
    @output.print "#{message}\n"
  end
end



# Main program
# robot = ToyRobotSimulator.new
# robot.run_simulation

require 'rspec'
require_relative '/home/lenovo/Desktop/assignment1/toy_robot_simulator.rb'

describe ToyRobotSimulator do
  let(:toy_robot) { described_class.new }

  describe '#run_simulation' do
    context 'with valid commands' do
      it 'executes a sequence of commands' do
        commands = [
          ['PLACE', 0, 0, 'NORTH'],
          ['MOVE'],
          ['LEFT'],
          ['MOVE'],
          ['RIGHT'],
          ['REPORT']
        ]

        expect { toy_robot.run_simulation(commands) }
          .to output(/Current position: 0, 1, NORTH/).to_stdout
      end
    end

    context 'with invalid X PLACE command' do
      it 'ignores the invalid X PLACE command' do
        commands = [
          ['PLACE', 5, 0, 'NORTH']
        ]

        expect { toy_robot.run_simulation(commands) }
          .to output(/Invalid PLACE command. Ignoring./).to_stdout
      end
    end

    context 'with invalid Y PLACE command' do
      it 'ignores the invalid Y PLACE command' do
        commands = [
          ['PLACE', 0, 5, 'NORTH']
        ]

        expect { toy_robot.run_simulation(commands) }
          .to output(/Invalid PLACE command. Ignoring./).to_stdout
      end
    end

    context 'with invalid MOVE command' do
      it 'ignores the MOVE command that goes out of bounds' do
        commands = [
          ['PLACE', 0, 0, 'WEST']
        ]

        expect { toy_robot.run_simulation(commands) }
          .to output("").to_stdout
      end
    end

    context 'with invalid commands' do
      it 'ignores the invalid commands' do
        commands = [
          ['INVALID_COMMAND'],
          ['PLACE',  0, 'NORTH']
        ]

        expect { toy_robot.run_simulation(commands) }
          .to output(/Invalid PLACE command. Ignoring/).to_stdout
      end
    end
  end

  describe '#move' do
    shared_examples 'moves to a valid position' do |initial_x, initial_y, direction, expected_position|
      it "moves the robot to a valid position #{direction}" do
        toy_robot.place(initial_x, initial_y, direction)
        toy_robot.move
        expect(toy_robot.report).to match("Current position: #{expected_position}")
      end
    end

    it_behaves_like 'moves to a valid position', 1, 1, 'NORTH', '1, 2, NORTH'
    it_behaves_like 'moves to a valid position', 1, 1, 'EAST', '2, 1, EAST'
    it_behaves_like 'moves to a valid position', 1, 1, 'WEST', '0, 1, WEST'
    it_behaves_like 'moves to a valid position', 1, 1, 'SOUTH', '1, 0, SOUTH'

    it 'ignores the MOVE command that goes out of bounds towards NORTH' do
      toy_robot.place(0, 4, 'NORTH')  # Robot at the top
      toy_robot.move
      expect(toy_robot.report).to match(/Current position: 0, 4, NORTH/)
    end

    it 'ignores the MOVE command that goes out of bounds towards EAST' do
      toy_robot.place(4, 0, 'EAST')  # Robot at the top
      toy_robot.move
      expect(toy_robot.report).to match("Current position: 4, 0, EAST")
    end

    it 'ignores the MOVE command that goes out of bounds towards WEST' do
      toy_robot.place(0, 4, 'WEST')  # Robot at the top
      toy_robot.move
      expect(toy_robot.report).to match("Current position: 0, 4, WEST")
    end

    it 'ignores the MOVE command that goes out of bounds towards SOUTH' do
      toy_robot.place(4, 0, 'SOUTH')  # Robot at the top
      toy_robot.move
      expect(toy_robot.report).to match("Current position: 4, 0, SOUTH")
    end
  end

  describe '#left' do
    shared_examples 'rotates to the left' do |initial_x, initial_y, direction, expected_position|
      it "rotates the robot to the left #{direction}" do
        toy_robot.place(initial_x, initial_y, direction)
        toy_robot.left
        expect(toy_robot.report).to match(/Current position: #{expected_position}/)
      end
    end

    it_behaves_like 'rotates to the left', 2, 2, 'EAST', '2, 2, NORTH'
    it_behaves_like 'rotates to the left', 2, 2, 'WEST', '2, 2, SOUTH'
    it_behaves_like 'rotates to the left', 2, 2, 'NORTH', '2, 2, WEST'
    it_behaves_like 'rotates to the left', 2, 2, 'SOUTH', '2, 2, EAST'
  end

  describe '#right' do
    shared_examples 'rotates to the right' do |initial_x, initial_y, direction, expected_position|
      it "rotates the robot to the right #{direction}" do
        toy_robot.place(initial_x, initial_y, direction)
        toy_robot.right
        expect(toy_robot.report).to match("Current position: #{expected_position}")
      end
    end

    it_behaves_like 'rotates to the right', 3, 3, 'SOUTH', '3, 3, WEST'
    it_behaves_like 'rotates to the right', 3, 3, 'NORTH', '3, 3, EAST'
    it_behaves_like 'rotates to the right', 3, 3, 'EAST', '3, 3, SOUTH'
    it_behaves_like 'rotates to the right', 3, 3, 'WEST', '3, 3, NORTH'
  end
end

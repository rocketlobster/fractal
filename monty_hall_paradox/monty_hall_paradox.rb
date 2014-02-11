# Calculates the probabilites for the Monty Hall Paradox

ii = 0
keeping_gain = 0
changing_gain = 0

while ii <= 10000000 do

doors = [0,1,2]
winning_door = rand(3)

player_first_door = rand(3)

left_doors = doors - [winning_door,player_first_door]

host_door = left_doors.sample

player_changed_door = (doors - [player_first_door, host_door]).first

if player_changed_door == winning_door
  changing_gain += 1
else player_first_door == winning_door
  keeping_gain += 1
end
ii += 1
end
puts "By sticking to his choice: #{keeping_gain.to_f/ii}"
puts "By changing from his choice: #{changing_gain.to_f/ii}"

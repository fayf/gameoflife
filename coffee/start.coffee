GOL = require('./gameoflife')

gol = new GOL(5, 5)

# for i in [0...25]
#   if Math.random() > 0.7 then gol.currGen[i].alive = true;

for i in [0,1,2,3,8,10,12,17,19,23]
  gol.currGen[i].alive = true;

for i in [0..5]
  # console.log gol.print(true)
  console.log gol.print()
  # console.log 'gen' + gol.generation, gol.currGen
  gol.tick()


BIRTH = [3] # Dead cell becomes alive
ALIVE = [2, 3] # Live cell stays alive, else dies

class GameOfLife
  constructor: (@sizeX, @sizeY) ->
    @generation = 0
    @currGen = []
    @nextGen = []
    for i in [0...@sizeX*@sizeY]
      @currGen[i] = @cell(false, true)
      @nextGen[i] = @cell(false, false)

  tick: ->
    c.dirty = false for c in @nextGen
    for cell, i in @currGen
      nextGenCell = @nextGen[i]
      if cell.dirty
        # Cell had changes in its neighbourhood
        neighbourIdxs = @neighbours i
        neighbours = (@currGen[idx] for idx in neighbourIdxs)
        n = (c for c in neighbours when c.alive).length

        if cell.alive
          if n in ALIVE
            nextGenCell.alive = true
          else
            nextGenCell.alive = false
            nextGenCell.dirty = true
            @nextGen[idx].dirty = true for idx in neighbourIdxs
        else
          if n in BIRTH
            nextGenCell.alive = true
            nextGenCell.dirty = true
            @nextGen[idx].dirty = true for idx in neighbourIdxs
          else
            nextGenCell.alive = false
      else
        nextGenCell.alive = cell.alive

    # Swap generations
    [@currGen, @nextGen] = [@nextGen, @currGen]
    @generation++
    return

  set: (i, alive) ->
    target = @currGen[i]
    if target.alive is not alive
      target.dirty = true
      @currGen[idx].dirty = true for idx in @neighbours i
    target.alive = alive
    return

  cell: (alive=false, dirty=false) ->
    alive: alive
    dirty: dirty

  neighbours: (i) ->
    [x, y] = @convert(i)
    switch x
      when 0
        startX = 0
        endX = 1
      when @sizeX-1
        startX = -1
        endX = 0
      else
        startX = -1
        endX = 1
    switch y
      when 0
        startY = 0
        endY = 1
      when @sizeY-1
        startY = -1
        endY = 0
      else
        startY = -1
        endY = 1
    ids = []
    for nx in [x+startX..x+endX]
     for ny in [y+startY..y+endY]
      ni = nx+ny*@sizeX
      if ni != i then ids.push nx+ny*@sizeX
    ids

  convert: (i) -> [i%@sizeY, i/@sizeY << 0]

  print: (binary) ->
    if binary
      return ((if c.alive then 1 else 0) for c in @currGen).join ''

    line = 'Generation ' + @generation + '\n'
    for c, i in @currGen
      if c.alive then line += '#'
      else line += '.'

      if i%@sizeX == @sizeX-1 and i != @sizeX*@sizeY-1
        line += '\n'
    line

module.exports = GameOfLife if typeof window is 'undefined'

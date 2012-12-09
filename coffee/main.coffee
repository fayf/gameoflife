class UI
  constructor: (@canvas, @cellsX, @cellsY, @colors) ->
    @ctx = @canvas.getContext '2d'
    @w = @canvas.width
    @h = @canvas.height
    @cellW = @w/@cellsX << 0
    @cellH = @h/@cellsY << 0
    @cellS = 0
    @ctx.strokeStyle = 'white'
    @ctx.fillStyle = 'black'

    if @cellS > 0 then @drawGrid()

  drawGrid: ->
    @ctx.lineWidth  = @cellS
    for i in [1...@cellsX]
      @ctx.moveTo i*@cellW, 0
      @ctx.lineTo i*@cellW, @h
    for i in [1...@cellsY]
      @ctx.moveTo 0, i*@cellH
      @ctx.lineTo @w, i*@cellH
    @ctx.stroke()

  drawCell: (x, y, alive) ->
    [x, y] = @getStartXY x, y
    [w, h] = @getDrawWH x, y
    if alive then @ctx.fillRect x, y, w, h
    else @ctx.clearRect x, y, w, h
    return

  getStartXY: (x, y) ->
    [
      if x is 0 then 0 else @cellS/2 + x*@cellW,
      if y is 0 then 0 else @cellS/2 + y*@cellH
    ]

  getDrawWH: (x, y) ->
    [
      @cellW - (if x is 0 then @cellS/2 else @cellS),
      @cellH - (if y is 0 then @cellS/2 else @cellS)
    ]

class Controller
  constructor: (@ui, @gol, @header, @speed, @gps) ->
    @paused = true

    @speed.attr 'value', @gps
    @speed.change =>
      try
        val = parseInt @speed.attr 'value'
      catch e
        val = @speed
      @gps = val
      console.log 'change', @speed
      if !@paused
        clearInterval @id
        @paused = true
        @toggle()
      return

    # Install click handler
    @c = $(@ui.canvas)
    @c.click (e) =>
      o = @c.offset()
      x = Math.floor (e.pageX-o.left)/@ui.cellW
      y = Math.floor (e.pageY-o.top)/@ui.cellH
      i = x+y*@gol.sizeX
      @gol.set i, !@gol.currGen[i].alive
      @draw()
      return
    @draw()

  toggle: ->
    @paused = !@paused
    if !@paused
      @draw()
      @id = setInterval(
        =>
          if @paused
            clearTimeout @id
            return
          @gol.tick()
          @draw()
        , 1000/@gps)
    return

  randomize: ->
    @gol.set i, Math.random() > 0.7 for c, i in @gol.currGen
    if !@paused then @toggle()
    @gol.generation = 0
    @draw()
    return

  clear: ->
    @gol.set i, false for c, i in @gol.currGen
    if !@paused then @toggle()
    @gol.generation = 0
    @draw()
    return

  draw: ->
    @header.html('Generation ' + @gol.generation)
    for c, i in @gol.currGen
      continue if not c.dirty
      [x, y] = @gol.convert i
      @ui.drawCell x, y, c.alive
    return

$(document).ready ->
  el = $('#canvas')[0]
  el.width = 500
  el.height = 500

  w = 100
  h = 100
  ui = new UI el, w, h
  gol = new GameOfLife w, h

  controller = new Controller ui, gol, $('#header'), $('#speed'), 50
  controller.randomize()

  $('#toggle').click -> controller.toggle()
  $('#randomize').click -> controller.randomize()
  $('#clear').click -> controller.clear()

  return

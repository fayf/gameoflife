canvasW = 500
canvasH = 500
containerH = 700

HTML lang: 'en',
  HEAD {},
    TITLE 'Conway\'s Game of Life'
    STYLE type: 'text/css',
      STYLE.on 'body'
        padding: '0px'
        margin: '0px'
        width: '100%'
        height: '100%'
        fontFamily: 'Helvetica, sans serif'
      STYLE.on '.container'
        position: 'absolute'
        width: canvasW+'px'
        height: containerH+'px'
        left: '50%'
        top: '50%'
        marginLeft: -canvasW/2+'px'
        marginTop: -containerH/2+'px'
        textAlign: 'center'
      STYLE.on 'canvas'
        width: canvasW+'px'
        height: canvasH+'px'
        backgroundColor: 'red'
      STYLE.on 'button'
        width: '100px'
        height: '40px'
        margin: '5px 0px 5px 5px'
      STYLE.on 'button:first-child'
        marginLeft: '0px'
    SCRIPT type: 'text/javascript', src: 'js/gameoflife.js'
    SCRIPT type: 'text/javascript', src: 'js/main.js'

  BODY {},
    DIV class: 'container',
      H2 id: 'header'
        'Generation 0'
      CANVAS id: 'canvas'
      DIV {},
        BUTTON id: 'toggle'
          'Start/Stop'
        BUTTON id: 'randomize'
          'Randomize'
        BUTTON id: 'clear'
          'Clear'
      LABEL 'Generations per second: '
      INPUT type: 'text', id: 'speed'

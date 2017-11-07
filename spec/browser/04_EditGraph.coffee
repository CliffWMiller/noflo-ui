describe 'Editing a graph', ->
  win = null
  doc = null
  ui = null
  editor = null
  graph = null
  before ->
    iframe = document.getElementById 'app'
    win = iframe.contentWindow
    doc = iframe.contentDocument

  describe 'initially', ->
    it 'should have a graph editor available', ->
      ui = doc.querySelector 'noflo-ui'
      editor = doc.querySelector 'the-graph-editor'
      chai.expect(editor).to.exist
      graph = doc.querySelector 'the-graph-editor the-graph'
      chai.expect(graph).to.exist
    it 'should have no nodes in the graph editor', ->
      nodes = doc.querySelectorAll 'the-graph g.nodes g.node'
      chai.expect(nodes.length).to.equal 0

  describe.skip 'help screen', ->
    help = null
    it 'should be visible initially', ->
      help = doc.querySelector 'noflo-help'
      chai.expect(help).to.exist
      chai.expect(help.visible).to.equal true
    it 'should go away after a click', (done) ->
      syn.click help
      setTimeout ->
        chai.expect(help.visible).to.equal false
        done()
      , 1

  describe 'runtime', ->
    runtime = null
    it 'should be available as an element', ->
      runtime = doc.querySelector 'noflo-runtime'
    it 'should have the IFRAME runtime selected', ->
      chai.expect(runtime.runtime).to.be.an 'object'
    it 'should connect automatically to the IFRAME provider', (done) ->
      @timeout 45000
      if runtime.online
        chai.expect(runtime.online).to.equal true
        done()
        return

      runtime.runtime.on 'status', (status) ->
        return unless status.online
        chai.expect(runtime.online).to.equal true
        done()

  describe 'component search', ->
    search = null
    it 'should initially show the breadcrumb', ->
      search = doc.querySelector 'noflo-search'
      chai.expect(search).to.exist
      chai.expect(search.classList.contains('overlay')).to.equal true
    it 'when clicked it should show the search input', (done) ->
      @timeout 10000
      breadcrumb = doc.querySelector 'noflo-search #breadcrumb'
      chai.expect(breadcrumb).to.exist
      setTimeout ->
        syn.click breadcrumb
        setTimeout ->
          chai.expect(search.classList.contains('overlay')).to.equal false
          done()
        , 500
      , 5000
    it 'should initially show results', (done) ->
      @timeout 30000
      if search.searchLibraryResults.length
        chai.expect(search.searchLibraryResults.length).to.be.above 10
        done()
        return

      checkResults = ->
        if search.searchLibraryResults and search.searchLibraryResults.length > 20
          chai.expect(search.searchLibraryResults.length).to.be.above 10
          return done()
        setTimeout checkResults, 1000
      setTimeout checkResults, 1000
    it 'should narrow them down when something is written', (done) ->
      @timeout 10000
      input = doc.querySelector 'noflo-search #search'
      syn.click(input)
      .type 'GetEle'

      checkResults = ->
        if search.searchLibraryResults and search.searchLibraryResults.length is 1
          chai.expect(search.searchLibraryResults.length).to.equal 1
          return done()
        setTimeout checkResults, 1000
      setTimeout checkResults, 1000
    it 'should add a node when result is clicked', (done) ->
      @timeout 7000
      context = doc.querySelector 'noflo-context'
      chai.expect(context).to.exist
      results = doc.querySelector 'noflo-context noflo-search-library-results'
      chai.expect(results).to.exist
      setTimeout ->
        getelement = doc.querySelector 'noflo-search-library-results li'
        chai.expect(getelement).to.exist
        syn.click getelement
        setTimeout ->
          nodes = doc.querySelectorAll 'the-graph g.nodes g.node'
          chai.expect(nodes.length).to.equal 1
          done()
        , 3000
      , 10

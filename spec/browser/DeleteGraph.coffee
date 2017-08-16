describe 'Deleting a graph', ->
  win = null
  doc = null
  ui = null
  editor = null
  graph = null
  modal = null

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

  describe 'graph settings', ->
    it 'should show the graph settings modal when clicked', (done) ->
      @timeout 7000
      search = doc.querySelector 'noflo-search'
      chai.expect(search).to.exist
      settingsButton = doc.querySelector 'noflo-search #graphinspector'
      chai.expect(settingsButton).to.exist
      setTimeout ->
        Syn.click settingsButton
        setTimeout ->
          modal = doc.querySelector 'noflo-graph-inspector'
          chai.expect(modal).to.exist
          done()
        , 500
      , 2000

  describe 'graph delete', ->
    it 'should remove the graph and project and redirect home', (done) ->
      @timeout 7000
      deleteButton = doc.querySelector 'noflo-graph-inspector .delete'
      chai.expect(deleteButton).to.exist
      setTimeout ->
        Syn.click deleteButton
        setTimeout ->
          hash = win.location.hash
          # workaround for ie
          if hash is '#'
            hash = ''
          chai.expect(hash).to.equal ''
          done()
        , 1500
      , 1500

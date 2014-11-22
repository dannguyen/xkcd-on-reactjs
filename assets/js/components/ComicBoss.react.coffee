xkcdx = window.Xkcdx ||= {}
xkcdx.ComicBoss = React.createClass
  getInitialState: ->
    filterText: ''

  handleUserInput: (filterText) ->
    this.setState( filterText: filterText )

  render: ->
    console.log 'wat'
    console.log "this props comics: #{this.props.comics.length}"
    comics_list = React.createElement( xkcdx.ComicsList, {
        comics: this.props.comics,
        filterText: this.state.filterText
      }
    )
    search_bar = React.createElement( xkcdx.SearchBar, {
        filterText: this.state.filterText,
        onUserInput: this.handleUserInput
      }
    )

    React.DOM.div null, search_bar, comics_list


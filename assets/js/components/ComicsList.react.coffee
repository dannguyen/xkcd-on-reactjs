xkcdx = window.Xkcdx ||= {}
xkcdx.Comic = React.createClass render: ->
  React.createElement 'a', { href: "http://xkcd.com/#{this.props.data.num}/"}, this.props.data.alt

xkcdx.ComicsList = React.createClass render: ->
  rows = []
  for comic in this.props.comics
    if (this.props.filterText.length > 2 &&
          comic.alt.indexOf(this.props.filterText) == -1 &&
          comic.transcript.indexOf(this.props.filterText) == -1)

    else
      rows.push React.DOM.li( {key: comic.num}, React.createElement(xkcdx.Comic, data: comic))
  React.DOM.ul null, rows

xkcdx.SearchBar = React.createClass(
  handleChange: ->
    this.props.onUserInput this.refs.filterTextInput.getDOMNode().value
  render: ->
    input = React.createElement 'input',
      type: 'text',
      placeholder: 'Search...',
      value: this.props.filterTextInput,
      ref: 'filterTextInput',
      onChange: this.handleChange

    form = React.DOM.form null, input
)

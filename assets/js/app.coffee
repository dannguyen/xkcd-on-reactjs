DATA_URL = '/data/xkcds.json'
$.ajax
  url: DATA_URL
  dataType: 'json'
  success: (data) =>
    console.log data.length
    React.render(
      React.createElement Xkcdx.ComicBoss, comics: data
      document.getElementById 'xkcd-boss'
    )
  error: (xhr, status, err) =>
    console.error DATA_URL, status, err.toString()

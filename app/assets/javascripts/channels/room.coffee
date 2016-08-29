App.room = App.cable.subscriptions.create "RoomChannel",


  connected: ->
    # Called when the subscription is ready for use on the server
      alert("You connected to room")
  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
      location.reload()

  speak: (message) ->
    @perform 'speak', message: message





App.room = App.cable.subscriptions.create "RoomChannel",

  connected: ->
    # Called when the subscription is ready for use on the server
      #alert("You connected to room")
  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
     # location.reload()

    if data.message?
      $('.chat_content').append @renderChat(data)
    else
      $("#carts").load(location.href + " #carts");

  renderChat: (data) ->
    data.user.email + ':' + '<b>' + data.message + '</b><br>'

  speak: (message) ->
    @perform 'speak', message: message

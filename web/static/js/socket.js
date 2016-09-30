// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket, Presence} from "phoenix"


let userToken = document.getElementById('user_id')
let roomID = document.getElementById('room_id')

if (userToken) {
  userToken = userToken.value
  roomID = roomID.value
} else {
  userToken = null
  roomID = null
}

// let socket = new Socket("/socket", {params: {user: "opan"}})
let socket = new Socket("/socket", {params: {token: userToken, room_id: roomID}})

let mainFunction = ()=> {

  // When you connect, you'll often need to authenticate the client.
  // For example, imagine you have an authentication plug, `MyAuth`,
  // which authenticates the session and assigns a `:current_user`.
  // If the current user exists you can assign the user's token in
  // the connection for use in the layout.
  //
  // In your "web/router.ex":
  //
  //     pipeline :browser do
  //       ...
  //       plug MyAuth
  //       plug :put_user_token
  //     end
  //
  //     defp put_user_token(conn, _) do
  //       if current_user = conn.assigns[:current_user] do
  //         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
  //         assign(conn, :user_token, token)
  //       else
  //         conn
  //       end
  //     end
  //
  // Now you need to pass this token to JavaScript. You can do so
  // inside a script tag in "web/templates/layout/app.html.eex":
  //
  //     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
  //
  // You will need to verify the user token in the "connect/2" function
  // in "web/channels/user_socket.ex":
  //
  //     def connect(%{"token" => token}, socket) do
  //       # max_age: 1209600 is equivalent to two weeks in seconds
  //       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
  //         {:ok, user_id} ->
  //           {:ok, assign(socket, :user, user_id)}
  //         {:error, reason} ->
  //           :error
  //       end
  //     end
  //
  // Finally, pass the token on connect as below. Or remove it
  // from connect if you don't care about authentication.

  socket.connect()

  // Now that you are connected, you can join channels with a topic:
  // let channel = socket.channel("topic:subtopic", {})
  // channel.join()
  //   .receive("ok", resp => { console.log("Joined successfully", resp) })
  //   .receive("error", resp => { console.log("Unable to join", resp) })

  let presences = {}

  let formatTimestamp = (timestamp) => {
    let date = new Date(timestamp)
    return date.toLocaleTimeString()
  }

  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
      onlineAt: formatTimestamp(metas[0].online_at),
      room: metas[0].room
    }
  }

  let userList = document.getElementById('user_list')
  let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence => `
        <li>
          ${presence.user}
          <br>
          <small>onine since ${presence.onlineAt}</small>
          <small><b>at ${presence.room}</b></small>
        </li>
      `)
      .join("")
  }

  let channel = socket.channel(`sinorang:${roomID}`, {token: userToken});
  let messageInput = document.getElementById('user_new_message')
  messageInput.addEventListener("keypress", (e)=> {
    if (e.keyCode == 13 && messageInput.value != ""){
      channel.push("message:new", messageInput.value)
      messageInput.value = ""
    }
  })

  let messageList = document.getElementById('message_list')
  let renderMessage = (message) => {
    let messageElement = document.createElement("li")
    messageElement.innerHTML = `
      <b>${message.user}</b>
      <i>${formatTimestamp(message.timestamp)}</i>
      <p>${message.body}</p>
    `
    messageList.appendChild(messageElement)
    messageList.scrollTop = messageList.scrollHeight

  }

  channel.on("message:new", message => renderMessage(message))

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render(presences)
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render(presences)
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}

// Run socket only if userToken exists
if (userToken){
  mainFunction()
}

export default socket

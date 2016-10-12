// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket, Presence} from "phoenix"


let userToken = document.getElementById('user_id')
let subtopicId = document.getElementById('subtopic_id')
let chatType = document.getElementById('chat_type')

userToken = (userToken) ? userToken.value : null
subtopicId = (subtopicId) ? subtopicId.value : null
chatType = (chatType) ? chatType.value : null

// let socket = new Socket("/socket", {params: {user: "opan"}})
let socket = new Socket("/socket", {
    params: {
      token: userToken, subtopic_id: subtopicId, chat_type: chatType
    }
  }
)

let global_socket = new Socket("/global_socket", {
  params: {}
})
global_socket.connect();
let global_channel = global_socket.channel(`global:1`, {})
console.log("lewat");

global_channel.join()
  .receive("ok", resp => { console.log("sukses", resp)})
  .receive("error", resp => { console.log("error", resp)})

let formatTimestamp = (timestamp) => {
  let date = new Date(timestamp)
  return date.toLocaleTimeString()
}

let presences = {}

let userList = document.getElementById('user_list')

let plainChatFunction = ()=> {

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

  let channel = socket.channel(`sinorang:${subtopicId}`, {token: userToken});
  let messageInput = document.getElementById('user_new_message')
  messageInput.addEventListener("keypress", (e)=> {
    if (e.keyCode == 13 && messageInput.value != ""){
      // channel.push() can send an object as parameters
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

  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
      onlineAt: formatTimestamp(metas[0].online_at),
      room: metas[0].room
    }
  }

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

  channel.on("message:new", message => renderMessage(message))

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render(presences)
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render(presences)
  })

  channel.on("push_notifications", payload => {
    alert(payload.message)
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}


let discussionVoteFunction =  ()=> {

  socket.connect();
  let channel = socket.channel(`discussion:${subtopicId}`, {token: userToken});

  let messageInput = document.getElementById('user_new_message')
  messageInput.addEventListener("keypress", (e)=> {
    if (e.keyCode == 13 && messageInput.value != ""){
      // channel.push() can send an object as parameters
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

  let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence => `
        <li>
          ${presence.user}
          <br>
          <small>onine since ${presence.onlineAt}</small>
          <small><b>at ${presence.discussion}</b></small>
        </li>
      `)
      .join("")
  }

  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
      onlineAt: formatTimestamp(metas[0].online_at),
      discussion: metas[0].discussion_name
    }
  }

  channel.on("message:new", message => renderMessage(message))

  channel.on("polling:vote", payload => {
    let tbodyContent = []
    payload.discussion_votings.forEach((vote)=>{
      tbodyContent.push(`
      <tr>
        <td class="text-center">
          <b>${vote.title}</b>
        </td>
        <td class="text-center">
          ${vote.score}
        </td>
        <td>
          <a href="/discussions/${payload.discussion.id}/votings/${vote.id}/upvote" class="btn btn-xs btn-primary"
            data-vote-btn="true">
            Upvote
          </a>
          |
          <a href="/discussions/${payload.discussion.id}/votings/${vote.id}/downvote" class="btn btn-xs btn-danger"
            data-vote-btn="true">
            Downvote
          </a>
        </td>
      </tr>
      `)
    })

    document.getElementById("discusion_votings_content").innerHTML = `
      <tbody>
        ${tbodyContent.join("")}
      </tbody>
    `

  })

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render(presences)
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render(presences)
  })

  channel.on("push_notifications", payload => {
    alert(payload.message)
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}

if (chatType == "plain_chat"){
  plainChatFunction()
} else if (chatType == "discussion_vote_chat") {
  discussionVoteFunction()
}

export default socket

let discussions = {
  init: ()=> {
    if ($('[data-cont="ac-votings Elixir.Rumbl.DiscussionController"]').length > 0) discussions.votings()
  },
  votings: ()=> {
    $(document)
      .on("click", "[data-vote-btn=true]", (e)=> {
        e.preventDefault()
        let url = $(e.target).attr("href")
        let promise = $.ajax({
          url: url,
          method: "PUT"
        })

        promise.done((data)=>{
        })

        promise.fail((error, xhr, status)=>{
          console.log(error)
        })
      })
  }
}

$(function(){
  discussions.init()
})

  $(document).ready(function (){
  console.log("hi")
  id= 2
  // id = <%= @channel.id %>
  // get_messages(id);
});

function get_messages(cid) {

  console.log("/channel/" + cid + "/messages");
  data = $.ajax({
    dataType: "json",
    type: "GET",
    // channel_id should be dynamic
    url: "/channel/" + cid + "/messages",
    async: false
  }).success(function(data){      
  }).responseText;

  data = JSON.parse(data)
  total = ""
  for (var i = 0; i < data['messages'].length; i++) {
      
      message = data['messages'][i]
      username = message['user']
      body = "<p>"+ "<strong>" + username + "</strong>" +  ": "+message['body']+"</p>"
      total+=body
      
  };
  $('#chatbox').html(total);
  setTimeout(function(){get_messages(cid);}, 720); 
}

function post_message(cid,message){

   $.ajax({
    url: '/channel/'+cid+'/post', 
    type: 'POST',
    data: {'channel_id': cid, 'body': message},
  })
  .done(function() {
    console.log("success");
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });
}

function click_send(){
  message = $("#message_input").val()
  post_message(id, message)
}
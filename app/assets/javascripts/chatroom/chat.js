$(document).ready(function (){
  id= 2
  // id = <%= @channel.id %>
  // get_messages(id);
  $(".follow").click(function(event) {
    type = $(this).html()
    console.log("---"+this.id)
    if (type == "Follow"){
      follow_from_channel(this.id)
    }else if(type == "Unfollow"){
      unfollow(this.id)
    }
  });
  
});

function add_active(id){
  // alert("called1");
  $.ajax({
    url: '/channel/add_active',
    type: 'POST',
    data: {"cid": id},
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

function delete_active(id){
  $.ajax({
    url: '/channel/delete_active',
    type: 'POST',
    data: {"cid": id},
    async: false
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
  return null;
}

function update_active(id){
  $.ajax({
    url: '/channel/update_active',
    type: 'POST',
    data: {"cid": id},
    async: false
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
  return null;
}

function follow_from_channel(id){
  $.ajax({
    url: '/channel/follow',
    type: 'POST',
    data: {"api_id": id},
  })
  .done(function() {
    toggleFollowButton(true)
    console.log("success");
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });
}

function get_userlist(cid) {
  data = $.ajax({
    dataType: "json",
    type: "GET",
    // channel_id should be dynamic
    url: "/channel/active/" + cid,
    async: false
  }).success(function(data){      
  }).responseText;
  data = JSON.parse(data)
  total = "<h3> Names </h3>"
  for (var i = 0; i < data['user_list'].length; i++) {
    username = data['user_list'][i]
    body = '<p><strong>' + username + '</strong></p>'
    total+=body
  };
  $('#userbox').html(total);

  if(document.URL.indexOf('channel/' + cid) > -1)
     content = setTimeout(function(){get_userlist(cid);}, 5000); 
  else
    clearTimeout(content)
}

function get_messages(cid) {

  var old_height = $('#chatbox').prop('scrollHeight');

  console.log("/channel/" + cid + "/messages");
  data = $.ajax({
    dataType: "json",
    type: "GET",
    // channel_id should be dynamic
    url: "/channel/" + cid + "/messages",
    async: false
  }).success(function(data){      
  }).responseText;

  update_active(cid);
  data = JSON.parse(data)
  total = ""
  for (var i = 0; i < data['messages'].length; i++) {
      message = data['messages'][i]
      username = message['user']
      body = "<p id=\"message"+ i.toString + "\">" + "<strong>" + username + "</strong>" +  ": "+message['body']+"</p>"
      total+=body
  };
  $('#chatbox').html(total);
  var new_height = $('#chatbox').prop('scrollHeight');
  if(new_height > old_height){
    $("#chatbox").animate({ scrollTop: new_height }, 'normal');
  }

  if(document.URL.indexOf('channel/'+cid) > -1)
    content = setTimeout(function(){get_messages(cid);}, 720); 
  else
    clearTimeout(content)
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
  document.getElementById("message_input").value = "";
  post_message(id, message)
}
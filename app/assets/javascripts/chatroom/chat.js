$(document).ready(function (){
  id= 2
  // id = <%= @channel.id %>
  // get_messages(id);
  $(".follow").click(function(event) {
    type = $(this).html()
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
  })
  .done(function() {
    console.log("success update_active");
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
  total = "<h3>User List</h3>"
  for (var i = 0; i < data['user_list'].length; i++) {
    username = data['user_list'][i]
    body = '<p>' + '<img src=\"/assets/user.png\" width=\"25px\" height=\"25px\" >' + '<strong>' + username + '</strong></p>'
    total+=body
  };
  $('#userbox').html(total);

  if(document.URL.indexOf('channel/' + cid) > -1)
     content = setTimeout(function(){get_userlist(cid);}, 5000); 
  else
    clearTimeout(content)
}


function emotify(message) {
  emo_message = message
  emo_message = emo_message.replace(/:\)/g, '<img src=\"/assets/smile.png\" width=\"35px\" height=\"35px\" title=":)">')
  emo_message = emo_message.replace(/:D/g, '<img src=\"/assets/big-smile.png\" width=\"35px\" height=\"35px\" title=":D">')
  emo_message = emo_message.replace(/\>:\(/g, '<img src=\"/assets/angry.png\" width=\"35px\" height=\"35px\">')
  emo_message = emo_message.replace(/:\(/g, '<img src=\"/assets/sad.png\" width=\"35px\" height=\"35px\" title=":(">')
  emo_message = emo_message.replace(/:'\(/g, '<img src=\"/assets/cry.png\" width=\"35px\" height=\"35px\" title=":\'(">')
  emo_message = emo_message.replace(/;\)/g, '<img src=\"/assets/winking.png\" width=\"35px\" height=\"35px\" title=";)">')
  emo_message = emo_message.replace(/o.O/g, '<img src=\"/assets/confused.png\" width=\"35px\" height=\"35px\" title="o.O">')

  emo_message = emo_message.replace(/=:-O/g, '<img src=\"/assets/afraid.png\" width=\"35px\" height=\"35px\" title="=:-O">')

  emo_message = emo_message.replace(/8-}/g, '<img src=\"/assets/silly.png\" width=\"35px\" height=\"35px\" title="8-}">')
  emo_message = emo_message.replace(/=\^..\^=/g, '<img src=\"/assets/cat.png\" width=\"35px\" height=\"35px\" title="=^..^=">')
  emo_message = emo_message.replace(/:3-]/g, '<img src=\"/assets/dog.png\" width=\"35px\" height=\"35px\" title=":3-]">')
  
  // 100% more Kappa
  emo_message = emo_message.replace(/Kappa/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-ddc6e3a8732cb50f-25x28.png" title="Kappa">')
  emo_message = emo_message.replace(/PJSalt/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-18be1a297459453f-36x30.png" >')
  emo_message = emo_message.replace(/BibleThump/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-f6c13c7fc0a5c93d-36x30.png" >')
  emo_message = emo_message.replace(/BrainSlug/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-d8eee0a259b7dfaa-30x30.png" >')
  emo_message = emo_message.replace(/FrankerZ/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-3b96527b46b1c941-40x30.png" >')

  return emo_message
}

function get_messages(cid) {
  update_active(cid);

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
  setDataView(data)

  if(document.URL.indexOf('channel/'+cid) > -1)
    content = setTimeout(function(){get_messages(cid);}, 720); 
  else
    clearTimeout(content)
}

function setDataView(data){
  var old_height = $('#chatbox').prop('scrollHeight');
  total = ""
  for (var i = 0; i < data['messages'].length; i++) {
      message = data['messages'][i]
      username = message['user']
      body = "<p id=\"message" + i.toString + "\">" + "<strong>" + username + "</strong>" +  ": " + emotify(message['body']) + "</p>"
      total+=body
  };
  $('#chatbox').html(total);
  var new_height = $('#chatbox').prop('scrollHeight');
  if(new_height > old_height){
    $("#chatbox").animate({ scrollTop: new_height }, 'normal');
  }
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

// Here need some backend for topic post and get url

// function post_topic(cid,topic){
//   $.ajax({
//     url: '/channel/' + cid + '/topic',
//     type: 'POST',
//     data: {'channel_id': cid, 'body':topic},
//   })
//   .done(function() {
//     console.log("success");
//   })
//   .fail(function() {
//     console.log("error");
//   })
//   .always(function() {
//     console.log("complete");
//   });
// }

// function get_topics(){
//   data = $.ajax({
//     dataType: "json",
//     type: "GET",
//     //url: "/channel/active/" + cid,
//     async: false
//   }).success(function(data){      
//   }).responseText;
  
//   data = JSON.parse(data)
//   total = "<h3>Topics:</h3>"
//   for (var i = 0; i < data['user_list'].length; i++) {
//     topic_name = data['topic_list'][i]
//     body = '<p>' + '<strong>' + topic_name + '</strong></p>'
//     total+=body
//   };
//   $('#topicbox').html(total);
//   if(document.URL.indexOf('channel/' + cid) > -1)
//      content = setTimeout(function(){get_topics(cid);}, 5000); 
//   else
//     clearTimeout(content)
// }

function click_add_topic_button() {
  bootbox.prompt("Please enter topic name:", function(topic) {                
    if (topic === null) {                                             
      bootbox.alert("failed");
    } else {
      bootbox.alert(topic);
      //post_topic(id, topic);
    }
  });
}

function click_send(){
  message = $("#message_input").val()
  document.getElementById("message_input").value = "";
  post_message(id, message)
}
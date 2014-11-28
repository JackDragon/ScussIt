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

  $(".topics").click(function(event) {
    topic_listener(this.id)
  });

  
});

function topic_listener(cid){
  $.ajax({
    url: '/channel/'+cid+'/topics',
    type: 'GET',
    dataType: 'json',
  })
  .done(function(data) {
    topics = data['topics']
    btTopics = {}
    i = 2
    for (var i = 0; i < topics.length; i++) {
      name = topics[i]['name']
      

      btTopics[name] = { 
        label: "#"+name,
        className: "btn-topics btn-primary",
        id: cid,
      }
    };
    bootbox.dialog({
      message: "See what's trending!",
      title: "#Topics",
      buttons: btTopics
    });

    buttonTopicsListener(cid)
    
  })
  .fail(function() {
    
  })
  .always(function() {
    
  });
  
}
function buttonTopicsListener(cid){
  $('.btn-topics').click(function(event) {
    get_messsages_by_topic($(this).attr("data-bb-handler"), cid);
  });
}
function get_messsages_by_topic(name,id){
  tag = name;
  lastMessageID = null;
}

function add_active(id){
  $.ajax({
    url: '/channel/add_active',
    type: 'POST',
    data: {"cid": id},
    async: false
  })
  .done(function() {
    
  })
  .fail(function() {
    
  })
  .always(function() {
    
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
    
  })
  .fail(function() {
    
  })
  .always(function() {
    
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

  })
  .fail(function() {
    
  })
  .always(function() {
    
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
    
  })
  .fail(function() {
    
  })
  .always(function() {
    
  });
}



function get_userlist(cid) {
  data = $.ajax({
    dataType: "json",
    type: "GET",
    url: "/channel/active/" + cid,
    async: false
  }).success(function(data){      
  }).responseText;
  data = JSON.parse(data)
  
  total = "<h3>User List</h3>"
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


/*
  The emoticons are from http://www.webiconset.com/
  Free Licence
*/
// emotifies symbols to emoticons
function emotify(message) {
  emo_message = message
  emo_message = emo_message.replace(/:\)/g, '<img src=\"/assets/smile.png\" width=\"35px\" height=\"35px\" title=\":)\">')
  emo_message = emo_message.replace(/:D/g, '<img src=\"/assets/big-smile.png\" width=\"35px\" height=\"35px\" title=\":D\">')
  emo_message = emo_message.replace(/\>:\(/g, '<img src=\"/assets/angry.png\" width=\"35px\" height=\"35px\">')
  emo_message = emo_message.replace(/:\(/g, '<img src=\"/assets/sad.png\" width=\"35px\" height=\"35px\" title=\":(\">')
  emo_message = emo_message.replace(/:'\(/g, '<img src=\"/assets/cry.png\" width=\"35px\" height=\"35px\" title=\":\'(\">')
  emo_message = emo_message.replace(/;\)/g, '<img src=\"/assets/winking.png\" width=\"35px\" height=\"35px\" title=\";)\">')
  emo_message = emo_message.replace(/o.O/g, '<img src=\"/assets/confused.png\" width=\"35px\" height=\"35px\" title=\"o.O\">')
  emo_message = emo_message.replace(/=:-O/g, '<img src=\"/assets/afraid.png\" width=\"35px\" height=\"35px\" title=\"=:-O\">')
  emo_message = emo_message.replace(/8-}/g, '<img src=\"/assets/silly.png\" width=\"35px\" height=\"35px\" title=\"8-}\">')
  emo_message = emo_message.replace(/=\^..\^=/g, '<img src=\"/assets/cat.png\" width=\"35px\" height=\"35px\" title=\"=^..^=\">')
  emo_message = emo_message.replace(/:3-]/g, '<img src=\"/assets/dog.png\" width=\"35px\" height=\"35px\" title=\":3-]\">')
  emo_message = emo_message.replace(/<3/g, '<img src=\"/assets/Heart.png\" width=\"35px\" height=\"35px\" title=\"<3\">')
  emo_message = emo_message.replace(/:P/g, '<img src=\"/assets/Tongue.png\" width=\"35px\" height=\"35px\" title=\":P\">')
  emo_message = emo_message.replace(/:\*/g, '<img src=\"/assets/Kiss.png\" width=\"35px\" height=\"35px\" title=\":\*\">')
  emo_message = emo_message.replace(/<\/3/g, '<img src=\"/assets/Broken-Heart.png\" width=\"35px\" height=\"35px\" title=\"<\/3\">')
  emo_message = emo_message.replace(/.~\*/g, '<img src=\"/assets/Bomb.png\" width=\"35px\" height=\"35px\" title=\".~\*\">')
  emo_message = emo_message.replace(/@}--\'--/g, '<img src=\"/assets/Flower.png\" width=\"35px\" height=\"35px\" title=\"@}--\'--\">')
  emo_message = emo_message.replace(/\}:-\)/g, '<img src=\"/assets/Devil.png\" width=\"35px\" height=\"35px\" title=\"\}:-\)\">')
  emo_message = emo_message.replace(/\{\}/g, '<img src=\"/assets/Hug.png\" width=\"35px\" height=\"35px\" title=\"\{\}\">')
  emo_message = emo_message.replace(/\(-_-\)zzz/g, '<img src=\"/assets/sleep.png\" width=\"35px\" height=\"35px\" title=\"\(-_-\)zzz\">')
  emo_message = emo_message.replace(/\(\'-\'\)y-~~/g, '<img src=\"/assets/Smoking.png\" width=\"35px\" height=\"35px\" title=\"\(\'ー\'\)y-~~\">')
  emo_message = emo_message.replace(/\|-O/g, '<img src=\"/assets/Yawn.png\" width=\"35px\" height=\"35px\" title=\"\|-O\">')  

  // 100% more Kappa from http://static-cdn.jtvnw.net
  // emo_message = emo_message.replace(/Kappa/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-ddc6e3a8732cb50f-25x28.png" title="Kappa">')
  // emo_message = emo_message.replace(/PJSalt/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-18be1a297459453f-36x30.png" title="PJSalt">')
  // emo_message = emo_message.replace(/BibleThump/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-f6c13c7fc0a5c93d-36x30.png" title="BibleThump">')
  // emo_message = emo_message.replace(/BrainSlug/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-d8eee0a259b7dfaa-30x30.png" title="BrainSlug">')
  // emo_message = emo_message.replace(/FrankerZ/g, '<img src=\"http://static-cdn.jtvnw.net/jtv_user_pictures/chansub-global-emoticon-3b96527b46b1c941-40x30.png" title="FrankerZ">')

  return emo_message
}


var content;
var tag; 
var lastMessageID; 

function get_messages(cid, name) {
  
  name = tag
  name = typeof name !== 'undefined' ? name : "Main";

  // console.log("last", lastMessageID)
  // console.log("tag", tag )
  
  
  // update_active(cid);
  //set default value for name if its not passed
  url_link = "/channel/"+id+"/messages"  
  if(name == "Main"){
    params = {}
  }else{
    params = {"topic": name}
  }
  
  
  data = $.ajax({
    dataType: "json",
    type: "GET",
    url: url_link,
    data: params,
    async: false
  }).success(function(data){      
  }).responseText;

  update_active(cid);
  
  data = JSON.parse(data)
  msgs = data['messages']

  if(msgs.length != 0 && lastMessageID != msgs[msgs.length-1]['id']){
    console.log("re-render")
    setDataView(data)
    
  }

  
  if(document.URL.indexOf('channel/'+cid) > -1)
    content = setTimeout(function(){get_messages(cid, name);}, 720); 
  else
    clearTimeout(content)
}

function setDataView(data){
  var old_height = $('#chatbox').prop('scrollHeight');
  total = ""
  for (var i = 0; i < data['messages'].length; i++) {
      message = data['messages'][i]
      username = message['user']
      body = "<p id=\"message" + i + "\">" + "<strong>" + username + "</strong>" +  ": " + emotify(message['body']) + "</p>"
      total+=body
  };
  $('#chatbox').html(total);
  var new_height = $('#chatbox').prop('scrollHeight');
  if(new_height > old_height){
    $("#chatbox").animate({ scrollTop: new_height }, 'normal');
  }
  lastMessageID = msgs[msgs.length-1]['id']
  

}

function post_message(cid, message){
  $.ajax({
    url: '/channel/'+cid+'/post', 
    type: 'POST',
    data: {'channel_id': cid, 'body': message},
  })
  .done(function() {
    tag = "Main"
    lastMessageID = null;
    
  })
  .fail(function() {
    
  })
  .always(function() {
    
  });
}


function post_topic(cid){
  $.ajax({
    url: "/channel/" + cid + "/add_topic",
    type: 'POST',
    data: {'channel_id': cid},
  })
  .done(function() {
    
  })
  .fail(function() {
    
  })
  .always(function() {
    
  });
}


function click_send(){
  message = $("#message_input").val()
  document.getElementById("message_input").value = "";
  post_message(id, message)
}
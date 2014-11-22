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

function add_active(id, topics){
  // alert("called1");
  $.ajax({
    url: '/channel/add_active',
    type: 'POST',
    // a list of one topic names
    data: {"cid": id,"topic_names": topics},
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
    //topic_name is a list of topic names
    data: {"cid": id, "topic_name":topic_list},
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


// json
//{topic1:[name1, name2], topic2:[name3, name4]}
function get_userlist(cid, topic) {
  alert(1)
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
  data = data[topic]
  console.log(data)
  for (var i = 0; i < data.length; i++) {
    username = data[i]
    body = '<p>' + '<img src=\"/assets/user.png\" width=\"25px\" height=\"25px\" >' + '<strong>' + username + '</strong></p>'
    total+=body
  };
  $('#userbox').html(total);

  if(document.URL.indexOf('channel/' + cid) > -1)
     content = setTimeout(function(){get_userlist(cid);}, 5000); 
  else
    clearTimeout(content)
}


// emotifies symbols to emoticons
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

// get messages from /channel/cid/messages
// cid is dynamic
//
//
//
//[{user body topic_name}{}{}]
function get_messages(cid) {
  // update_active(cid);

  console.log("/channel/" + cid + "/messages");
  data = $.ajax({
    dataType: "json",
    type: "GET",
    // channel_id should be dynamic
    url: "/channel/" + cid + "/messages",
    async: false
  }).success(function(data){      
  }).responseText;

  // update_active(cid);
  data = JSON.parse(data)
  setDataView(data)

  if(document.URL.indexOf('channel/'+cid) > -1)
    content = setTimeout(function(){get_messages(cid);}, 720); 
  else
    clearTimeout(content)
}
/*
        <!-- Sample code which is generated by javascript
          <div class="tab-pane fade" id="topic1">
            Tab 1 content
          </div>
          <div class="tab-pane fade" id="topic2">
            Tab 2 content
          </div>
        -->
*/
//[{user body topic_name}{}{}]
function setDataView(data){
  var old_height = $('#chatbox').prop('scrollHeight');
  messages = data['messages']
  topics = {}
  for (var i = 0; i < messages.length; i++) {
    username = messages[i]['user']
    message = messages[i]['body']
    topic_name = messages[i]['topic_name']
    if(topic_name in topics) {
      // var arr = topics[topic_name]
      topics[topic_name].push([username, message])
    } else {
      topics[topic_name] = []
      topics[topic_name].push([username, message])
    }
  };
  total = ""


  for (topic in topics) {
    total += "<div class=\"tab-pane fade\" id=\"" + topic + "\">" + "\n"
    for (var i = 0; i < topics[topic].length; i++) {
      total += "<p><strong>" + topics[topic][i][0] + ": " + "</strong>" + topics[topic][i][1] + "</p>" + "\n"
    };
    total += "</div>" + "\n"
  };
  // console.log(total)
  $('#chatbox').html(total);
  var new_height = $('#chatbox').prop('scrollHeight');
  if(new_height > old_height){
    $("#chatbox").animate({ scrollTop: new_height }, 'normal');
  }
}

function post_message(cid, topic, message){
  $.ajax({
    url: '/channel/'+cid+'/post', 
    type: 'POST',
    //need to get the topic name
    data: {'channel_id': cid, 'body': message, 'topic_name':topic},
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

//Here need some backend for topic post and get url

function post_topic(cid, topic){
  alert(1)
  $.ajax({
    url: "/channel/" + cid + "/add_topic",
    type: 'POST',
    data: {'channel_id': cid, 'topic_names':[topic]},
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


function get_topics(cid){
  data = $.ajax({
    dataType: "json",
    type: "GET",
    url: '/channel/' + cid + '/topics',
    async: false
  }).success(function(data){      
  }).responseText;
  // alert('getting data')
  data = JSON.parse(data)
  total = ""
  total = "<h3>Topics:</h3>"
  total += '<ul class="nav nav-tabs nav-stacked">'
  for (var i = 0; i < data['topics'].length; i++) {
    topic_name = data['topics'][i]
    body =  "<li><a href=\"#" + topic_name + "\"" + " data-toggle=\"tab\">"+ topic_name + "</a></li>"
    // console.log(body)
    total += body
  };
  total += '</ul>'
  $('#topicbox').html(total);
  if(document.URL.indexOf('channel/' + cid) > -1)
     content = setTimeout(function(){get_topics(cid);}, 5000); 
  else
    clearTimeout(content)
}

function click_add_topic_button() {
  bootbox.prompt("Please enter topic name:", function(topic) {                
    if (topic === null) {                                             
      bootbox.alert("failed to topics");
    } else {
      post_topic(id, topic)
    }
  });
}

function click_send(){
  message = $("#message_input").val()
  document.getElementById("message_input").value = "";
  //post_message(id, topic, message)
  post_message(id, 'Topic1', 'testing')
}
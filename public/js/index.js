$('.btn-chat').click(function() {
  var name = $('input[name=name]').val();
  var message = $('input[name=message]').val();
  if(!name) {
    name = '<empty-name>';
  }
  if(!message) {
    message = '<empty-message>';
  }

  var transport = new Thrift.Transport('/chat');
  var protocol = new Thrift.Protocol(transport);
  var client = new ChatSvcClient(protocol);

  var success = client.say(name, message);
});

io = io.connect()
io.on('say', function(data) {
  var line = data.line;
  line = line.replace('&', '&amp;');
  line = line.replace('<', '&lt;').replace('>', '&gt;');

  $('ul').prepend('<li>' + line + '</li>');
})


function makeid() {
  //http://stackoverflow.com/questions/1349404/generate-a-string-of-5-random-characters-in-javascript
  var text = "";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for( var i=0; i < 5; i++ ) {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return text;
}

$(function() {
  $('input[name=name]').val(makeid());
})

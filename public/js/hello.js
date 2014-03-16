$('#btn').click(function() {
  var transport = new Thrift.Transport("/hello");
  var protocol  = new Thrift.Protocol(transport);
  var client = new HelloSvcClient(protocol);
  var msg = client.hello_func();
  document.getElementById("output").innerHTML = msg;
});

$('#btnDbl').click(function() {
  var transport = new Thrift.Transport("/dbl");
  var protocol  = new Thrift.Protocol(transport);
  var client = new TimesTwoClient(protocol);
  var val = client.dbl(25);
  document.getElementById("output2").innerHTML = val;
});

$('#btn-chat').click(function() {
  var transport = new Thrift.Transport('/chat');
  var protocol = new Thrift.Protocol(transport);
  var client = new ChatSvcClient(protocol);
  var msg = client.send('name', 'msg');
  alert(msg);
});

io = io.connect()

io.emit('ready')

io.on('new visitor', function() {
  $('body').append('<p>New visitor, hooray! ' + new Date().toString() +'</p>')
})

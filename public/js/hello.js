$('#btn').click(function() {
  var transport = new Thrift.Transport("http://localhost:3000/hello");
  var protocol  = new Thrift.Protocol(transport);
  var client = new HelloSvcClient(protocol);
  var msg = client.hello_func();
  document.getElementById("output").innerHTML = msg;
});

$('#btnDbl').click(function() {
  var transport = new Thrift.Transport("http://localhost:3000/dbl");
  var protocol  = new Thrift.Protocol(transport);
  var client = new TimesTwoClient(protocol);
  var val = client.dbl(25);
  document.getElementById("output2").innerHTML = val;
});

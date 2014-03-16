service HelloSvc {
  string hello_func(),
}

service TimesTwo {
  i64 dbl(1: i64 val),
}

service ChatSvc {
  void send(1:string name, 2:string msg),
  void receive(1:string name, 2:string msg, 3:string timestamp),
}
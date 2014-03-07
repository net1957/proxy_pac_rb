function FindProxyForURL(url, host) {
  if ( MyIpAddress() == '127.0.0.2' ) {
    return "DIRECT";
  } else {
    return "PROXY localhost:8080";
  }
}

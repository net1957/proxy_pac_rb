function FindProxyForURL(url, host) {
  if ( myIpAddress() == '127.0.0.2' ) {
    return "DIRECT";
  } else {
    return "PROXY localhost:8080";
  }
}

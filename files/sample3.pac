function FindProxyForURL(url, host) {
  if ( timeRange(8, 18) ) {
    return "PROXY localhost:8080";
  } else {
    return "DIRECT";
  }
}

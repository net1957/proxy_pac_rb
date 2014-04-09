function FindProxyForURL(url, host) {
  if (isInNet(myIpAddress(), "10.0.0.0", "255.255.255.0")) {
    return 'PROXY localhost:3128';
  } else {
    return 'DIRECT';
  }
}
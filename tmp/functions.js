  function dnsDomainIs(host, domain) {
      return (host.length >= domain.length &&
              host.substring(host.length - domain.length) == domain);
  }
  
  function dnsDomainLevels(host) {
      return host.split('.').length - 1;
  }
  
  function convert_addr(ipchars) {
      var bytes = ipchars.split('.');
      var result = ((bytes[0] & 0xff) << 24) |
                   ((bytes[1] & 0xff) << 16) |
                   ((bytes[2] & 0xff) <<  8) |
                    (bytes[3] & 0xff);
      return result;
  }
  
  function isInNet(ipaddr, pattern, maskstr) {
      var test = /^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$/.exec(ipaddr);
      if (test == null) {
          ipaddr = dnsResolve(ipaddr);
          if (ipaddr == null)
              return false;
      } else if (test[1] > 255 || test[2] > 255 || 
                 test[3] > 255 || test[4] > 255) {
          return false;    // not an IP address
      }
      var host = convert_addr(ipaddr);
      var pat  = convert_addr(pattern);
      var mask = convert_addr(maskstr);
      return ((host & mask) == (pat & mask));
      
  }
  
  function isPlainHostName(host) {
      return (host.search('\\\\.') == -1);
  }
  
  function isResolvable(host) {
      var ip = dnsResolve(host);
      return (ip != null);
  }
  
  function localHostOrDomainIs(host, hostdom) {
      return (host == hostdom) ||
             (hostdom.lastIndexOf(host + '.', 0) == 0);
  }
  
  function shExpMatch(url, pattern) {
     pattern = pattern.replace(/\\./g, '\\\\.');
     pattern = pattern.replace(/\\*/g, '.*');
     pattern = pattern.replace(/\\?/g, '.');
     var newRe = new RegExp('^'+pattern+'$');
     return newRe.test(url);
  }
  
  var wdays = {SUN: 0, MON: 1, TUE: 2, WED: 3, THU: 4, FRI: 5, SAT: 6};
  var months = {JAN: 0, FEB: 1, MAR: 2, APR: 3, MAY: 4, JUN: 5, JUL: 6, AUG: 7, SEP: 8, OCT: 9, NOV: 10, DEC: 11};
  
  ;

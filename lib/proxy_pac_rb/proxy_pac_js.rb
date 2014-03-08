# encoding: utf-8
module ProxyPacRb
  class ProxyPacJs
    class << self

      def my_ip_address_template(value)
        <<-EOS.strip_heredoc
          function MyIpAddress() {
            return "#{value}";
          }
        EOS
      end

      # taken from  releases-mozilla-release / netwerk / base / src / ProxyAutoConfig.cpp @ bitbucket.org
      # https://bitbucket.org/mozilla/releases-mozilla-release/raw/dece38633cf1adcab2071d69fea264580d24cc9e/netwerk/base/src/ProxyAutoConfig.cpp
      def week_day_range_template(value = nil)
        value = %Q{"#{value}"} if value

        <<-EOS.strip_heredoc
      function weekdayRange() {
          function getDay(weekday) {
              if (weekday in wdays) {
                  return wdays[weekday];
              }
              return -1;
          }
          var date = new Date(#{value});
          var argc = arguments.length;
          var wday;
          if (argc < 1)
              return false;
          if (arguments[argc - 1] == 'GMT') {
              argc--;
              wday = date.getUTCDay();
          } else {
              wday = date.getDay();
          }
          var wd1 = getDay(arguments[0]);
          var wd2 = (argc == 2) ? getDay(arguments[1]) : wd1;
          return (wd1 == -1 || wd2 == -1) ? false
                                          : (wd1 <= wday && wday <= wd2);
      }
        EOS
      end

      def date_range_template(value = nil)
        value = %Q{"#{value}"} if value

        <<-EOS.strip_heredoc
      function dateRange() {
          function getMonth(name) {
              if (name in months) {
                  return months[name];
              }
              return -1;
          }
          var date = new Date(#{value});
          var argc = arguments.length;
          if (argc < 1) {
              return false;
          }
          var isGMT = (arguments[argc - 1] == 'GMT');

          if (isGMT) {
              argc--;
          }
          // function will work even without explict handling of this case
          if (argc == 1) {
              var tmp = parseInt(arguments[0]);
              if (isNaN(tmp)) {
                  return ((isGMT ? date.getUTCMonth() : date.getMonth()) ==
                           getMonth(arguments[0]));
              } else if (tmp < 32) {
                  return ((isGMT ? date.getUTCDate() : date.getDate()) == tmp);
              } else { 
                  return ((isGMT ? date.getUTCFullYear() : date.getFullYear()) ==
                           tmp);
              }
          }
          var year = date.getFullYear();
          var date1, date2;
          date1 = new Date(year,  0,  1,  0,  0,  0);
          date2 = new Date(year, 11, 31, 23, 59, 59);
          var adjustMonth = false;
          for (var i = 0; i < (argc >> 1); i++) {
              var tmp = parseInt(arguments[i]);
              if (isNaN(tmp)) {
                  var mon = getMonth(arguments[i]);
                  date1.setMonth(mon);
              } else if (tmp < 32) {
                  adjustMonth = (argc <= 2);
                  date1.setDate(tmp);
              } else {
                  date1.setFullYear(tmp);
              }
          }
          for (var i = (argc >> 1); i < argc; i++) {
              var tmp = parseInt(arguments[i]);
              if (isNaN(tmp)) {
                  var mon = getMonth(arguments[i]);
                  date2.setMonth(mon);
              } else if (tmp < 32) {
                  date2.setDate(tmp);
              } else {
                  date2.setFullYear(tmp);
              }
          }
          if (adjustMonth) {
              date1.setMonth(date.getMonth());
              date2.setMonth(date.getMonth());
          }
          if (isGMT) {
          var tmp = date;
              tmp.setFullYear(date.getUTCFullYear());
              tmp.setMonth(date.getUTCMonth());
              tmp.setDate(date.getUTCDate());
              tmp.setHours(date.getUTCHours());
              tmp.setMinutes(date.getUTCMinutes());
              tmp.setSeconds(date.getUTCSeconds());
              date = tmp;
          }
          return ((date1 <= date) && (date <= date2));
      }
        EOS
      end

      def time_range_template(value = nil)
        value = %Q{"#{value}"} if value

        <<-EOS.strip_heredoc
      function timeRange() {
          var argc = arguments.length;
          var date = new Date(#{value});
          var isGMT= false;

          if (argc < 1) {
              return false;
          }
          if (arguments[argc - 1] == 'GMT') {
              isGMT = true;
              argc--;
          }

          var hour = isGMT ? date.getUTCHours() : date.getHours();
          var date1, date2;
          date1 = new Date();
          date2 = new Date();

          if (argc == 1) {
              return (hour == arguments[0]);
          } else if (argc == 2) {
              return ((arguments[0] <= hour) && (hour <= arguments[1]));
          } else {
              switch (argc) {
              case 6:
                  date1.setSeconds(arguments[2]);
                  date2.setSeconds(arguments[5]);
              case 4:
                  var middle = argc >> 1;
                  date1.setHours(arguments[0]);
                  date1.setMinutes(arguments[1]);
                  date2.setHours(arguments[middle]);
                  date2.setMinutes(arguments[middle + 1]);
                  if (middle == 2) {
                      date2.setSeconds(59);
                  }
                  break;
              default:
                throw 'timeRange: bad number of arguments'
              }
          }

          if (isGMT) {
              date.setFullYear(date.getUTCFullYear());
              date.setMonth(date.getUTCMonth());
              date.setDate(date.getUTCDate());
              date.setHours(date.getUTCHours());
              date.setMinutes(date.getUTCMinutes());
              date.setSeconds(date.getUTCSeconds());
          }
          return ((date1 <= date) && (date <= date2));
      }
        EOS
      end
    end
  end
end

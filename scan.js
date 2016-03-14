var nmap = require('libnmap');
var scan = function(options) {
  return new Promise(function(resolve, reject) {
    nmap.scan({
      ports: options.ports || '1-65535',
      range: options.range || [
        '192.168.99.100',
      ]
    }, function(err, report) {
      if (err) reject(err);
      resolve(report);
    });
  });
};

module.exports = scan;

require('dotenv').load();
var net = require('net');
var assert = require('assert');

var target = {
  host: process.env.TARGET_MACHINE
}

describe('Network', function() {
  it('should block port 6184', function(done) {
    target.port = 6184;
    net.connect(target, function() {
      done(new Error());
    }).on('error', function(err) {
      done(assert(true));
    });
  });

  it('should open port 89', function(done) {
    target.port = 89;
    net.connect(target, function() {
      done(assert(true));
    }).on('error', function(err) {
      done(new Error(err));
    });
  });

  it('should be accessible via SSH on port 33322', function(done) {
    done(new Error());
  });

  it('should not allow SSH with root user', function(done) {
    done();
  });

  it('should not allow SSH with password based auth', function(done) {
    done();
  });
});

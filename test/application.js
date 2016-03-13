require('dotenv').load();
var net = require('net');
var assert = require('assert');

var target = {
  host: process.env.TARGET_MACHINE
}

describe('Application', function() {

  it('should run Hello Ops on port 80', function(done) {
    done();
  });

  it('should redirect to /{country_code} properly', function(done) {
    done();
  });
});

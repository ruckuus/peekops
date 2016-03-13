require('dotenv').load();
var net = require('net');
var assert = require('assert');

var target = {
  host: process.env.TARGET_MACHINE
}

describe('Web', function() {
  it('should run nginx on port 89', function(done) {
    done();
  });
});

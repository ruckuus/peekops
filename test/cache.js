require('dotenv').load();
var net = require('net');
var assert = require('assert');

var target = {
  host: process.env.TARGET_MACHINE
}

describe('Cache', function() {
  it('should run redis', function(done) {
    done();
  });
});

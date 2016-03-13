require('dotenv').load();
var net = require('net');
var assert = require('assert');

var target = {
  host: process.env.TARGET_MACHINE
}

describe('DB', function() {
  it('should run postgres', function(done) {
    done();
  });
});

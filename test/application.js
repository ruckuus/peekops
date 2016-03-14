require('dotenv').load();
var net = require('net');
var assert = require('assert');

var target = {
  host: process.env.APPLICATION_TARGET_MACHINE
}

describe('Application', function() {

  it('should run Hello Ops on port 80', function(done) {
    done();
  });

});

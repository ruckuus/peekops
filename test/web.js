require('dotenv').load();
var net = require('net');
var should = require('should');
var request = require('request');

describe('Web', function() {
  it('should run nginx on port 80', function(done) {
    request('http://' + process.env.WEB_TARGET_MACHINE + ':80', function(err, response, body) {
        if (err) {
          true.should.not.be.ok();
          done();
        }

        true.should.be.ok();
        done();
        });
  });
});

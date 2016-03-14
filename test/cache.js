require('dotenv').load();
var net = require('net');
var redis = require('redis');
var should = require('should');

describe('Cache', function() {
  it('should run redis', function(done) {
    var client = redis.createClient({ host: process.env.CACHE_TARGET_MACHINE });
    client.set('test_test', 'some_value', function(err, reply) {
      if (err) {
        true.should.not.be.ok();
        done();
      }
      true.should.be.ok();
      done();
    })
  });
});

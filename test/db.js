require('dotenv').load();
var pg = require('pg');
var net = require('net');
var should = require('should');

describe('DB', function() {
  it('should run postgres', function(done) {
    var cs = 'postgres://postgres:postgres@' + process.env.DATABASE_TARGET_MACHINE + '/postgres';
    var client = new pg.Client(cs);

    client.connect(function(err) {
      if (err) {
        false.should.be.ok();
        done();
      }
      true.should.be.ok();
      done();
    });
  });
});
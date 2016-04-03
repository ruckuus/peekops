require('dotenv').load();
var net = require('net');
var scan = require('../scan'); 
var should = require('should');
var result = []; 

describe('Network', function() {
  this.timeout(15000);
  before(function(done) {
    scan({
      range: [
        process.env.WEB_TARGET_MACHINE,
        process.env.CACHE_TARGET_MACHINE,
        process.env.DATABASE_TARGET_MACHINE,
        process.env.APPLICATION_TARGET_MACHINE
      ],
    }).then(function(report) {
      for (var item in report) {
        result[item] = [];

        for (var p of report[item].host[0].ports[0].port) {
          var row = {
            port: p.item.portid,
            prot: p.item.protocol,
            state: p.state[0].item.state,
            service: (p.service) ? p.service[0].item.name : 'NA'
          };

          result[item].push(row);
        }
      }
      done();
    }).catch(function(err) {
      throw Error(err);
    });
  });

  describe('Application Server', function() {
    it('Should open SSH port.', function(done) {
      result[process.env.APPLICATION_TARGET_MACHINE].should.containDeep(
          [{ port: '22', prot: 'tcp', state: 'open', service: 'ssh' }]
          );
      done();
    });

    it('Should block port 3000.', function(done) {
      result[process.env.APPLICATION_TARGET_MACHINE].should.not.containDeep(
          [{ port: '3000', state: 'open', service: 'ssh' }]
          );
      done();
    });

    it('Should block port 80.', function(done) {
      result[process.env.APPLICATION_TARGET_MACHINE].should.not.containDeep(
          [{ port: '80', state: 'open', service: 'ssh' }]
          );
      done();
    });
  });

  describe('Web Server', function() {
    it('Should open SSH port.', function(done) {
      result[process.env.WEB_TARGET_MACHINE].should.containDeep(
          [{ port: '22', prot: 'tcp', state: 'open', service: 'ssh' }]
          );
      done();
    });

    it('Should block port 3000.', function(done) {
      result[process.env.WEB_TARGET_MACHINE].should.not.containDeep(
          [{ port: '3000', state: 'open', service: 'ssh' }]
          );
      done();
    });

    it('Should open port 80.', function(done) {
      result[process.env.WEB_TARGET_MACHINE].should.containDeep(
          [{ port: '80', state: 'open', service: 'ssh' }]
          );
      done();
    });
  });

  describe('DB Server', function() {
    it('Should only open DB port.', function(done) {
      result[process.env.DATABASE_TARGET_MACHINE].should.have.lengthOf(1);
      done();
    });

    it('Should block SSH port.', function(done) {
      result[process.env.DATABASE_TARGET_MACHINE].should.not.containDeep(
          [{ port: '22', prot: 'tcp', state: 'open', service: 'ssh' }]
          );
      done();
    });

    it('Should open DB port.', function(done) {
      result[process.env.DATABASE_TARGET_MACHINE].should.containDeep(
          [{ port: '5432', prot: 'tcp', state: 'open', service: 'postgresql' }]
          );
      done();
    });
  });

  describe('DB Server', function() {
    it('Should only open Redis port.', function(done) {
      result[process.env.CACHE_TARGET_MACHINE].should.have.lengthOf(1);
      done();
    });

    it('Should block SSH port.', function(done) {
      result[process.env.CACHE_TARGET_MACHINE].should.not.containDeep(
          [{ port: '22', prot: 'tcp', state: 'open', service: 'ssh' }]
          );
      done();
    });

    it('Should open Redis port.', function(done) {
      result[process.env.CACHE_TARGET_MACHINE].should.containDeep(
          [{ port: '6379', prot: 'tcp', state: 'open' }]
          );
      done();
    });
  });


});

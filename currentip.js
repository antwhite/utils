#!/usr/bin/env node

var networkInterfaces = require('os').networkInterfaces();
var address = Object
    .keys(networkInterfaces)
    .filter(function (interfaceName) {
        return interfaceName.match(/^en/);
    })
    .reverse()
    .map(function (interfaceName) {
        return networkInterfaces[interfaceName];
    })
    .reduce(function (first, next) { return first.concat(next); }, [])
    .filter(function (interface) {
        return interface.family == 'IPv4'
    })
    .map(function (interface) {
        return interface.address;
    })
    .pop();
process.stdout.write(address + '\n');
process.exit(0);
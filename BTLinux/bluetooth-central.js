/**
* bluetooth-central.js
* a code to communicate with LE device, using noble 
*/

var async = require('async');
var noble = require('noble');

noble.on('stateChange', function(state) {
  if (state === 'poweredOn') {
  	console.log('scanning started');
    noble.startScanning();
  } else {
    noble.stopScanning();
  }
});

noble.on('discover', function(peripheral) {
  peripheral.connect(function(error) {
    console.log('connected to peripheral: ' + peripheral.uuid);

    peripheral.discoverServices(['740efdc9e0ce4b308c18577d8275c17f'], function(error, services) {
    	console.log(services.length + ' services found')

    	if (services.length > 0) {
    		noble.stopScanning();

    		var batteryService = services[0];
			console.log('Discovered Context Data service');

			batteryService.discoverCharacteristics(['534b0ed747de4e5a9e3eda4bd3b33d2e'], function(error, characteristics) {
				var batteryLevelCharacteristic = characteristics[0];
				console.log('Discovered Context Data characteristic');

				batteryLevelCharacteristic.on('read', function(data, isNotification) {
					//var now = moment()
					//var formatted = now.format('YYYY-MM-DD HH:mm:ss Z')
					console.log('received from '+peripheral.uuid+': '+ data.toString('hex'));
				  	// console.log('['+formatted+'] received from '+peripheral.uuid+': '+ data.toString('hex'));
				});

				// true to enable notify
				batteryLevelCharacteristic.notify(true, function(error) {
				  console.log('Context data notification is now on');
				});
			});
    	}
    });
  });
});


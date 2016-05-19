/**
* bluetooth-central.js
* a code to communicate with LE device, using noble 
*/

var async = require('async');
var noble = require('noble');

// noble.state = 'poweredOn';
// noble.startScanning();
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

    peripheral.discoverServices(['e20a39f473f54bc4a12f17d1ad666661'], function(error, services) {
    	console.log(services.length + ' services found')

    	if (services.length > 0) {
    		var batteryService = services[0];
			console.log('discoveredBatter service');

			batteryService.discoverCharacteristics(['08590f7edb05467e875772f6f66666d4'], function(error, characteristics) {
			var batteryLevelCharacteristic = characteristics[0];
			console.log('discovered Battery Level characteristic');

			batteryLevelCharacteristic.on('read', function(data, isNotification) {
			  console.log('battery level is now: ', data + '%');
			});

			// true to enable notify
			batteryLevelCharacteristic.notify(true, function(error) {
			  console.log('battery level notification on');
			});
			});
    	}
    });
  });
});


// noble.on('discover', function(peripheral) {
//   // if (peripheral.id === peripheralIdOrAddress || peripheral.address === peripheralIdOrAddress) {
//     // noble.stopScanning();

//     console.log('peripheral with ID ' + peripheral.id + ' found');
//     var advertisement = peripheral.advertisement;

//     var localName = advertisement.localName;
//     var txPowerLevel = advertisement.txPowerLevel;
//     var manufacturerData = advertisement.manufacturerData;
//     var serviceData = advertisement.serviceData;
//     var serviceUuids = advertisement.serviceUuids;

//     if (localName) {
//       console.log('  Local Name        = ' + localName);
//     }

//     if (txPowerLevel) {
//       console.log('  TX Power Level    = ' + txPowerLevel);
//     }

//     if (manufacturerData) {
//       console.log('  Manufacturer Data = ' + manufacturerData.toString('hex'));
//     }

//     if (serviceData) {
//       console.log('  Service Data      = ' + serviceData);
//     }

//     if (serviceUuids) {
//       console.log('  Service UUIDs     = ' + serviceUuids);
//     }

//     console.log();

//     explore(peripheral);
//   // }
// });

// function explore(peripheral) {
//   console.log('services and characteristics:');

//   peripheral.on('disconnect', function() {
//     process.exit(0);
//   });

//   peripheral.connect(function(error) {
//     peripheral.discoverServices([], function(error, services) {
//       var serviceIndex = 0;

//       async.whilst(
//         function () {
//           return (serviceIndex < services.length);
//         },
//         function(callback) {
//           var service = services[serviceIndex];
//           var serviceInfo = service.uuid;

//           if (service.name) {
//             serviceInfo += ' (' + service.name + ')';
//           }
//           console.log(serviceInfo);

//           service.discoverCharacteristics([], function(error, characteristics) {
//             var characteristicIndex = 0;

//             async.whilst(
//               function () {
//                 return (characteristicIndex < characteristics.length);
//               },
//               function(callback) {
//                 var characteristic = characteristics[characteristicIndex];
//                 var characteristicInfo = '  ' + characteristic.uuid;

//                 if (characteristic.name) {
//                   characteristicInfo += ' (' + characteristic.name + ')';
//                 }

//                 async.series([
//                   function(callback) {
//                     characteristic.discoverDescriptors(function(error, descriptors) {
//                       async.detect(
//                         descriptors,
//                         function(descriptor, callback) {
//                           return callback(descriptor.uuid === '2901');
//                         },
//                         function(userDescriptionDescriptor){
//                           if (userDescriptionDescriptor) {
//                             userDescriptionDescriptor.readValue(function(error, data) {
//                               if (data) {
//                                 characteristicInfo += ' (' + data.toString() + ')';
//                               }
//                               callback();
//                             });
//                           } else {
//                             callback();
//                           }
//                         }
//                       );
//                     });
//                   },
//                   function(callback) {
//                         characteristicInfo += '\n    properties  ' + characteristic.properties.join(', ');

//                     if (characteristic.properties.indexOf('read') !== -1) {
//                       characteristic.read(function(error, data) {
//                         if (data) {
//                           var string = data.toString('ascii');

//                           characteristicInfo += '\n    value       ' + data.toString('hex') + ' | \'' + string + '\'';
//                         }
//                         callback();
//                       });
//                     } else {
//                       callback();
//                     }
//                   },
//                   function() {
//                     console.log(characteristicInfo);
//                     characteristicIndex++;
//                     callback();
//                   }
//                 ]);
//               },
//               function(error) {
//                 serviceIndex++;
//                 callback();
//               }
//             );
//           });
//         },
//         function (err) {
//           peripheral.disconnect();
//         }
//       );
//     });
//   });
// }
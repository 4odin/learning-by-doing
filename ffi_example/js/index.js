const { load, open, close, DataType, funcConstructor } = require('ffi-rs');

// Define the Config structure equivalent in Node.js
const ConfigStruct = {
    x: DataType.I32,
    init_hook, // We'll handle the function type differently in Node.js
};

// Determine the dynamic library path and open it
const dynamicLib = '../main.dll'; // Adjust this path to your actual DLL
open({
    library: 'libsum', // Arbitrary key for referencing the library
    path: dynamicLib,
});

// Assuming `number` and `init_config` are defined in your C library,
// call `number` function
const resultFromNumber = load({
    library: 'libsum',
    funcName: 'number',
    retType: DataType.I32,
    paramsType: [DataType.I32],
    paramsValue: [3],
});
console.log("Result from number:", resultFromNumber);

let config = { x: 0, init_hook: undefined };

const my_init_func = (config, x) => {
    config.x = x;
};


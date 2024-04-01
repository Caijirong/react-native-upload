const minimist = require('minimist');
const args = minimist(process.argv.slice(2));

let packConfiguration = args.configuration;

if (!packConfiguration || typeof packConfiguration !== 'string') {
    packConfiguration = 'Release';
}

console.log(packConfiguration);
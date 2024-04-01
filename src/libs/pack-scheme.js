const minimist = require('minimist');
const args = minimist(process.argv.slice(2));

let packScheme = args.scheme;

if (!packScheme || typeof packScheme !== 'string') {
    packScheme = '';
}

console.log(packScheme);
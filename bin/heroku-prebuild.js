const fs = require('fs');
const os = require('os');
const path = require('path');

const npmrc = path.resolve(process.cwd(), '.npmrc');

const registryUrl = String(process.env.GITHUB_REGISTRY_URL);

console.log('npmrc: ', npmrc);
console.log('registry url: ', registryUrl);

const authString = registryUrl.replace(/(^\w+:|^)/, '') + ':_authToken=${GITHUB_NPM_TOKEN}';

const contents = `${authString}${os.EOL}`;

fs.writeFileSync(npmrc, contents);

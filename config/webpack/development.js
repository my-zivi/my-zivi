process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const environment = require('./environment');
const imageLoader = require('./loaders/image-webpack-loader');

environment.loaders.append('image-webpack-loader', imageLoader(false));

module.exports = environment.toWebpackConfig();

const { environment } = require('@rails/webpacker');
const webpack = require('webpack');
const MomentLocalesPlugin = require('moment-locales-webpack-plugin');
const path = require('path');

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
  h: ['preact', 'h'],
  Fragment: ['preact', 'Fragment'],
}));

environment.plugins.append('MomentLocalesPlugin', new MomentLocalesPlugin({
  localesToKeep: ['de', 'fr', 'it'],
}));

const leafletPathSegments = '../../node_modules/leaflet/dist/images';
environment.config.merge({
  resolve: {
    alias: {
      react: 'preact/compat',
      'react-dom/test-utils': 'preact/test-utils',
      'react-dom': 'preact/compat',
      'react/jsx-runtime': 'preact/jsx-runtime',
      './images/layers.png$': path.resolve(__dirname, `${leafletPathSegments}/layers.png`),
      './images/layers-2x.png$': path.resolve(__dirname, `${leafletPathSegments}/layers-2x.png`),
      './images/marker-icon.png$': path.resolve(__dirname, `${leafletPathSegments}/marker-icon.png`),
      './images/marker-icon-2x.png$': path.resolve(__dirname, `${leafletPathSegments}/marker-icon-2x.png`),
      './images/marker-shadow.png$': path.resolve(__dirname, `${leafletPathSegments}/marker-shadow.png`),
    },
  },
});

module.exports = environment;

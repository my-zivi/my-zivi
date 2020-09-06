const { environment } = require('@rails/webpacker');
const webpack = require('webpack');
const MomentLocalesPlugin = require('moment-locales-webpack-plugin');

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
}));

environment.plugins.append('MomentLocalesPlugin', new MomentLocalesPlugin({
  localesToKeep: ['de', 'fr', 'it'],
}));

environment.config.merge({
  "resolve": {
    "alias": {
      "react": "preact/compat",
      "react-dom/test-utils": "preact/test-utils",
      "react-dom": "preact/compat",
    },
  },
});

module.exports = environment;

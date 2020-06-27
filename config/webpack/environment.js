const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  // utils: ['falcon/js/theme/Utils.js', 'default'],
  // 'window.utils': 'falcon/js/theme/Utils.js',
  Popper: ['popper.js', 'default'],
}));

module.exports = environment;

// eslint-disable-next-line import/no-extraneous-dependencies
require('image-webpack-loader');

/**
 * @param {boolean} developmentMode Turn on to disable image optimization to improve loading speed
 */
module.exports = (developmentMode) => ({
  test: /\.(gif|png|jpe?g|svg)$/i,
  use: [
    {
      loader: 'image-webpack-loader',
      options: {
        disable: developmentMode,
      },
    },
  ],
});

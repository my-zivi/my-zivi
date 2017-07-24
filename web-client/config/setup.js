const { join } = require('path');
const webpack = require('webpack');
const ExtractText = require('extract-text-webpack-plugin');
const SWPrecache = require('sw-precache-webpack-plugin');
const Dashboard = require('webpack-dashboard/plugin');
const Clean = require('clean-webpack-plugin');
const Copy = require('copy-webpack-plugin');
const HTML = require('html-webpack-plugin');

const uglify = require('./uglify');
const babel = require('./babel');

const root = join(__dirname, '..');

module.exports = isProd => {
  isProd && babel.presets.push('babili');

  // base plugins array
  const plugins = [
    new Clean(['dist'], { root }),
    new Copy([{ context: 'src/static/', from: '**/*.*' }]),
    new webpack.optimize.CommonsChunkPlugin({ name: 'vendor' }),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(isProd ? 'production' : 'development'),
    }),
    new HTML({ template: 'src/index.html' }),
    new webpack.LoaderOptionsPlugin({
      options: {
        babel,
        postcss: [require('autoprefixer')({ browsers: ['last 3 version'] })],
      },
    }),
  ];

  if (isProd) {
    plugins.push(
      new webpack.LoaderOptionsPlugin({ minimize: true, debug: false }),
      new webpack.optimize.UglifyJsPlugin(uglify),
      new ExtractText('styles.[hash].css'),
      new SWPrecache({
        filename: 'service-worker.js',
        dontCacheBustUrlsMatching: /./,
        navigateFallback: 'index.html',
        staticFileGlobsIgnorePatterns: [/\.map$/],
      })
    );
  } else {
    // dev only
    plugins.push(new webpack.HotModuleReplacementPlugin(), new webpack.NamedModulesPlugin(), new Dashboard());
  }

  return plugins;
};

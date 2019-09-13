module.exports = (on, config) => {
  on('before:browser:launch', () => {
    require('../server/index');
  });
};

module.exports = {
  ci: {
    collect: {
      url: ['http://localhost:3000/'],
      startServerCommand: 'NO_SSL=true bin/rails server -e production',
    },
    upload: {
      target: 'temporary-public-storage',
    },
  },
};

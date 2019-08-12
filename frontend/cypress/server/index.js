const jsonServer = require('json-server');
const path = require('path');
const defaultValues = require('./defaults');
const defaultUser = require('./db').users[0];
const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
jsonServer.defaults({ noCors: true });

server.post('/v1/users/validate', (_, res) => {
  console.log('POST /v1/users/validate 204 :no_content');
  res.set('Access-Control-Allow-Origin', '*');
  res.status(204);
  res.send('');
});

server.post('/v1/users', (req, res) => {
  console.log('POST /v1/users 201 :created');
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Expose-Headers', 'Authorization, Content-Disposition');
  res.set('Authorization', defaultValues.authorization_token);
  res.status(201);
  res.send(JSON.stringify(defaultUser));
});

server.use(jsonServer.defaults());
server.use((req, res, next) => {
  res.set('Access-Control-Allow-Origin', '*');
  next();
});

server.use('/v1', router);
server.listen(28000, () => {
  console.log('JSON Server is running on port 28000');
});

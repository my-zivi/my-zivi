const jsonServer = require('json-server');
const path = require('path');
const defaultValues = require('./defaults');
const defaultUser = require('./db').users[0];
const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
jsonServer.defaults({ noCors: true });

function appendAccessControlHeaders(res) {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Expose-Headers', 'Authorization, Content-Disposition');
}

server.post('/v1/users/validate', (_, res) => {
  console.log('POST /v1/users/validate 204 :no_content');
  appendAccessControlHeaders(res);
  res.status(204);
  res.send('');
});

function appendAuthorizationHeader(res) {
  res.set('Authorization', defaultValues.authorization_token);
}

server.post('/v1/users', (req, res) => {
  console.log('POST /v1/users 201 :created');
  appendAccessControlHeaders(res);
  appendAuthorizationHeader(res);
  res.status(201);
  res.send(JSON.stringify(defaultUser));
});

server.post('/v1/users/sign_in', (req, res) => {
  console.log('POST /v1/users/sign_in 200 :ok');
  appendAccessControlHeaders(res);
  appendAuthorizationHeader(res);
  res.status(200);
  res.jsonp(defaultUser);
});

server.use(jsonServer.defaults());
server.use((req, res, next) => {
  appendAccessControlHeaders(res);
  next();
});

server.use('/v1', router);
server.listen(28000, () => {
  console.log('JSON Server is running on port 28000');
});

const fs = require('fs');
const path = require('path');

// COPY INITAL_DB.JSON TO DB.JSON FOR USAGE
fs.writeFileSync(path.join(__dirname, 'db.json'), fs.readFileSync(path.join(__dirname, 'initial_db.json'), 'utf8'));

const jsonServer = require('json-server');
const defaultValues = require('./defaults');
const server = jsonServer.create();
const defaultUser = require('./db').users[0];
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

function handleLogin(res, req, statusCode = 200) {
  let user = defaultUser;
  let authHeader = defaultValues.authorization_token;

  appendAccessControlHeaders(res);

  if (req.headers.authorization !== undefined) {
    const jwtContent = parseJwt(req.headers.authorization);

    if (jwtContent.isAdmin) {
      user = require('./db').user[1]
      authHeader = defaultValues.admin_authorization_token;
    }
  }

  appendAuthorizationHeader(res, authHeader);
  res.status(statusCode);
  res.jsonp(user)
}

function parseJwt (token) {
  var base64Url = token.split('.')[1];
  var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
  var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
  }).join(''));

  return JSON.parse(jsonPayload);
};

function appendAuthorizationHeader(res, authorization_token) {
  res.set('Authorization', authorization_token);
}

server.post('/v1/users', (req, res) => {
  console.log('POST /v1/users 201 :created');
  handleLogin(res, req, 201);
});

server.post('/v1/users/sign_in', (req, res) => {
  console.log('POST /v1/users/sign_in 200 :ok');
  handleLogin(res, req);
});

server.use(jsonServer.defaults());
server.use((req, res, next) => {
  appendAccessControlHeaders(res);
  next();
});

server.get('/v1/expense_sheets/:expensesheetId/hints', (req, res) => {
  res.jsonp({
    "suggestions": {
      "work_days": 20,
      "workfree_days": 6,
      "paid_company_holiday_days": 0,
      "unpaid_company_holiday_days": 0,
      "clothing_expenses": 5980
    },
    "remaining_days": {
      "sick_days": 5,
      "paid_vacation_days": 0
    }
  })
});

// RESETS THE DB TO INITIAL DB VALUES
server.use((req, res, next) => {
  if (req.method === 'POST' && req.path === '/db:reset') {
    const initialData = fs.readFileSync(path.join(__dirname, 'initial_db.json'), 'utf8');
    fs.writeFileSync(path.join(__dirname, 'db.json'), initialData);
    router.db.setState(JSON.parse(initialData));
    res.sendStatus(200);
  } else {
    next();
  }
});

// REMOVE DB.JSON
server.use((req, res, next) => {
  if (req.method === 'POST' && req.path === '/db:remove') {
    fs.unlinkSync(path.join(__dirname, 'db.json'));
    res.sendStatus(200);
  } else {
    next();
  }
});

server.use('/v1', router);
server.listen(28000, () => {
  console.log('JSON Server is running on port 28000');
});

## About 
Coffescript REST API example using JWT and OAuth strategy based on Node.js/MongoDB and Express.js/Mongoose.

## Get started
To start just use this code in your terminal:
```sh
$ git clone https://github.com/nazicrim/coffeescript-rest-jwt.git
$ cd coffeescript-rest-jwt/
$ npm install
$ npm start
```
If you would like to use another version of CoffeScript/npm/Node,js you can change it in your package.json file.

## API directory structure
There are a simple files tree:

    .
    ├── bin                                 # Directory with main server .coffee files
    ├── services                            # API controllers 
        ├── auth                            
            ├── index.coffee                # Expess.Router with all '/auth' routes
            └── controllers
                └── AuthController.coffee
        ├── models                          # All API db mongoose models
            ├── AuthToken.coffee            
            ├── ClientAuth.coffee
            └── User.coffee
        ├── CheckAuth.coffee                # Method of checking is user has authentithicated
        └── index.coffee                    # Returns all service routes
    ├── helpers                             # Helpers classes and methods
        └── error
            └── Error.coffe
    ├── app.coffee                          # The main application settings
    └── package.json
    
To extand this API by new controllers you just have to create new folder in `services` directory and add it to the `services/index.coffee` file. The same situation with `helpers`.
    
## OAuth strategy
We have 3 mongoose models using in authentithication:
  - User model includes 5 fields:
    - name:	     `{ type: String, required: true, default: "undefined" }`
    - username:  `{ type: String, required: true, default: "undefined", unique: true }`
    - password:  `{ type: String, required: true, default: "password" }`
    - email: 	   `{ type: String, required: true, default: "admin@Admin.com" }`
    - signin_at: `{ type: Date, default: Date.now }`
  - Client model includes 3 fields:
    - username: 	   `{ type: String, required: true, unique: true }`
    - permissions:   `{ type: Number, required: false, default: 0 } # 0 - simple user, 1 - moderator, 2 - admin, 3 - sudo`
    - client_secret: `{ type: String, required: true }`
  - Token model includes 2 fields:
    - access_token: `{ type: String, required: true }`
    - client:	 	    `{ type: String, required: true }`

Registered user would have 2 documents in collections User and Client, after sign in he takes a Token document. If you would like to access closed area you have to send 'x-auth' header. API would check if Client/Token models exist then he will compare `Client.client_secret field` with `access_token`. To sign out just send GET request and Token model (equals your req.headers['x-auth'] token) would be removed.

##### Json Web Token structure: `{ permissions: client.permissions, expires: 	 _date }`

## Routes
This example enjoy some simple routes.
### '/'
The main route of REST API application.
  - GET request `/` - to send: `none`. Returns information about server.
### '/auth'
Authentithication route to controll the auth service.
  - POST request `/auth/signup` - to send: `{ name: "name", username: "username", password: "password", email: "email@email.com", date: new Date }`. Creating new user.
  - POST request '/auth/signin' - to send: `{ username: "username", password: "password" }`. Creating new Token document and sending access_token to you.
  - GET request '/auth/signout' - to send: `Header: 'x-auth' = 'your access_token'`. Just deleting your `'access_token'` in DB storage.
  - GET request '/auth' - to send: `Header: 'x-auth' = 'your access_token'`. Returns you your `'access_token'`
  

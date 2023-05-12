# Week 3 — Decentralized Authentication

## Lecture Videos

   - [FREE AWS Cloud Project Bootcamp (Week 3) - Decentralized Authenication](https://www.youtube.com/watch?v=9obl7rVgzJw&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=41)
   - [Week 3 Cognito Custom Pages!](https://www.youtube.com/watch?v=T4X4yIzejTc&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=42)
   - [Week 3 Congito JWT Server side Verify](https://www.youtube.com/watch?v=d079jccoG-M&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=43)
   - [Week 3 - Exploring JWTs](https://www.youtube.com/watch?v=nJjbI4BbasU&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=44)

## Required Homework

### Setup Cognito User Pool

This week we provisioned an AWS Cognito User Pool using clickOps and integrated it with the frontend of our app. To perform this we performed the following:

    - Set the required environment variables in docker-compose.yml
    - Import 'Auth' from aws-amplify in app.js, HomeFeedPage.js, and SigninPage.js
    - In app.js, passed environmanet variables to configure Amplify and Auth for our application
    - updated 'onsubmit' actions in the SigninPage.js file to integrate with Cognito.

##### Setting the required environement variables for frontend-react service in docker-compose.yml

```yaml
  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      # Cognito Env Vars
      REACT_APP_AWS_PROJECT_REGION: "${AWS_DEFAULT_REGION}"
      REACT_APP_AWS_COGNITO_REGION: "${AWS_DEFAULT_REGION}"
      REACT_APP_AWS_USER_POOLS_ID: "us-####-#-#########"
      REACT_APP_CLIENT_ID: "################"
```

##### Import 'Auth' from aws-amplify in app.js and pass env vars for configuration

```js
import { Amplify } from 'aws-amplify';

Amplify.configure({
  "AWS_PROJECT_REGION": process.env.REACT_APP_AWS_PROJECT_REGION,
  "aws_cognito_region": process.env.REACT_APP_AWS_COGNITO_REGION,
  "aws_user_pools_id": process.env.REACT_APP_AWS_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_CLIENT_ID,
  "oauth": {},
  Auth: {
    // We are not using an Identity Pool
    // identityPoolId: process.env.REACT_APP_IDENTITY_POOL_ID, // REQUIRED - Amazon Cognito Identity Pool ID
    region: process.env.REACT_APP_AWS_PROJECT_REGION,           // REQUIRED - Amazon Cognito Region
    userPoolId: process.env.REACT_APP_AWS_USER_POOLS_ID,         // OPTIONAL - Amazon Cognito User Pool ID
    userPoolWebClientId: process.env.REACT_APP_CLIENT_ID,   // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
  }
})
```
##### Updated 'onsubmit' actions in the SigninPage.js file to integrate with Cognito

```js
import { Auth } from 'aws-amplify';

  const onsubmit = async (event) => {
    setErrors('')
    event.preventDefault();
    Auth.signIn(email, password)
      .then(user => {
        console.log('user',user)
        localStorage.setItem("access_token", user.signInUserSession.accessToken.jwtToken)
        window.location.href = "/"
      })
      .catch(error => {
        if (error.code == 'UserNotConfirmedException') {
          window.location.href = "/confirm"
        }
        setErrors(error.message)
      });
    return false
  }
```

We created a user within our user pool using the AWs Console to test out our sign-in page. This was a roundabout method because we bypassed using the sign-up page. Upon creation, our user was in a state where we needed to update the password in order to successfully login with this user.

### Custom Sign-in page

Ran the following CLI command to force change the password due to the nature in which we created this user. 

```bash
aws cognito-idp admin-set-user-password --user-pool-id <user-pool-id> --username <username> --password <password> --permanent
```

Once the password was updated, I was able to login successfully into our application. I also went in and added a 'preferred_username' attribute to my user, so that the handle would be updated to reflect the proper user. 

![Successful Login with Cognito User](assets/week3/successful-login-with-cognito-user.png)

Also successfully tested the sign out functionality.

### Custom Signup Page and Confirmation Page

I updated both the SignupPage.js and ConfirmationPage.js per Andrew's instructions. My initial attempt to sign up failed due to a configuration setting on the user pool, so I had to recreate selecting only 'email' as the desired user pool sign-in option.  Once completed, I attempted to sign up again. This time it was successful and I was redirected to the expected confirmation page. 

I verified that I received an email and entered in the confirmation code. Once verified, I validated that the user was created in my Cognito User Pool.

![](assets/week3/funtional-custom-confirmation-page.png)

![](assets/week3/cognito-user-created-from-successful-signup.png)

Finally, I confirmed that I could sign in and the home page appeared as expected.

![](assets/week3/successful-login-with-cognito-user.png)


I did some additional UX testing out of curiosity. First, I  attempted to sign up with a new user but used the same email. As expected it caused an error because an account with that email already existed. 

![](assets/week3/signup-page-duplicate-email-attempt.png)

Next, I tested the 're-send confirmation code' functionality for posterity, and it proved to be successful. However, I noted two things: 1) You can only re-send the code one time and 2) it actually doesn't send the same code twice.

![](assets/week3/confirmation-page-resend-code.png)

### Custom Recovery Page

By this point, the pattern for updating our custom pages (replacing default cookies) was set. Added the code, and began testing out the functionality. My test was successful, I received an email and proceeded to reset my password, and test the login. 

![Pasword recovery landing page](assets/week3/recovery-page-landing-page.png)

![successful password reset](assets/week3/password-reset-sucessfully.png)


### JWT - Server-Side Verification

In order to truly understand what was needed to accomplish this task, I needed to do some research on JWTs and python object-oriented programing. 
I read through this blog <https://supertokens.com/blog/what-is-jwt> about JWT and learned a lot about what they are, how they are used and their pros/cons.  JSON Web Tokens are used to share information between 2 clients; they contain JSON objects known as claims that are hashed to ensure JSON contents cannot be altered by either a client or malicious party. From my understanding, once a user signed in with the proper credentials in Cognito, an access token was passed to our frontend and was initially stored locally. The HomeFeedPage.js integrates with our backend by sending an API to our configured backend URL. To configure server-side verification, we needed to pass the access token with this API call to our backend. This was accomplished by adding the following code to HomeFeedPage.js.

```js
{
        headers: {
          Authorization: `Bearer ${localStorage.getItem("access_token")}`
        }
```

##### Resulting in the following code block:
![HomeFeedPage-attach-access-token](assets/week3/HomeFeedPage-attach-access-token.png)

How do we verify that the access token was successfully sent in the header? How can we read the token in our backend-flask?

The next issue to solve was to figure out how to read request headers in flask.

We imported the requests module into `app.py` to enable the import of request objects (in this case the header), and adjusted the @app.route for `/api/activities/home` endpoint so that the 'Authorization' request header could be read in flask. This introduced a CORS error, which was resolved by the adding some additional logic with the following code:

```py
frontend = os.getenv('FRONTEND_URL')
backend = os.getenv('BACKEND_URL')
origins = [frontend, backend]
cors = CORS(
  app, 
  resources={r"/api/*": {"origins": origins}},
  headers=['Content-Type', 'Authorization'], 
  expose_headers='Authorization',
  methods="OPTIONS,GET,HEAD,POST"
)
```

This code leveraged our preset environment variables for the frontend and backend urls along with the CORS function from the flask_cors module. Once added, refreshing the webpage displayed the AUTH HEADER and the value of the access token thus confirming that our backend was able to receive the incoming JWT.
	
![Token Attestation](assets/week3/auth-header-with-token-evidence.png)

This access token is our encoded JWT, and we needed to implement a way for our application to perform server-side verification of our token. The server-side verification process consists of decoding the access token/JWT and validating the token against what is valid in AWS Cognito.

To accomplish this, we grabbed code from the following places:

   - <https://github.com/cgauge/Flask-AWSCognito/tree/master/flask_awscognito>
   - <https://github.com/cgauge/Flask-AWSCognito/blob/master/flask_awscognito/services/token_service.py>
   - <https://github.com/cgauge/Flask-AWSCognito/blob/master/flask_awscognito/exceptions.py>
   - <https://github.com/cgauge/Flask-AWSCognito/blob/master/flask_awscognito/utils.py> 

The resulting `cognito_jwt_token.py` [code](https://github.com/fo-momoh/aws-bootcamp-cruddur-2023/blob/prod/backend-flask/lib/cognito_jwt_token.py).

Ran into 2 key issues when integrating cognito_jwt_token into `app.py`.

#### *Issue 1*
The first issue is that we were unable to properly pass the access token to cognito_jwt_token function resulting in an error in the verification process. I knew from previous steps that the header was being passed successfully to our backend endpoint, so there was certainly data being passed. I opted to print out the value of the variable `access_token` (which was derived by the `extract_access_token` function in our module). The error message stated that the "CognitoJwtToken.extract_access_token() takes 1 positional argument but 2 were given". It returned 2 values in the "Bearer ####" format; this was confusing because the extract_access_token method had conditional logic to split the access token and return the 2nd value if a space was present. Moving the method outside of the CognitoJwtToken class and making it an independent function appeared to be the solution. 

#### *Issue 2*
The second issue took far longer than needed to be resolved. The error message is detailed in the image below.

![](assets/week3/corrected-extract-access-token-method-error-with-missing-token-service.png)

Essentially, the token_service was a remnant of the source code we leveraged. In that code, it created a token service that essentially performed the token generation and verification server-side. As we only needed the verification portion, the error was resolved once we removed references to token_service. 

The updated portions of code for `app.py` are displayed below. 

```py
cognito_jwt_token = CognitoJwtToken(
  user_pool_id=os.getenv("AWS_COGNITO_USER_POOL_ID"), 
  user_pool_client_id=os.getenv("AWS_COGNITO_USER_POOL_CLIENT_ID"), 
  region=os.getenv("AWS_DEFAULT_REGION")
  )


@app.route("/api/activities/home", methods=['GET'])
def data_home():
  access_token = extract_access_token(request.headers)
  try:
    claims = cognito_jwt_token.verify(access_token)
    # authenticated request
    app.logger.debug('authenticated')
    app.logger.debug(claims)
    app.logger.debug(claims['username'])
    data = HomeActivities.run(cognito_user_id=claims['username'])
  except TokenVerifyError as e:
    # unauthenticated request
    app.logger.debug(e)
    app.logger.debug('unauthenticated')
    data = HomeActivities.run()
  return data, 200
```

![](assets/week3/finally-authenticated.png)

One nice thing that came out of all the troubleshooting efforts is that we saw the errors appearing in rollbar.

![](assets/week3/rollbar-errors-from-jwt-verification-testing.png)





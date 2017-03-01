#LoginPageExample

This is a very simple example project consisting of only a Login screen with two input fields and a button. Behind the UI there's some dummy logic that simluates a network request. Trying to login with 

**email:** test@storytel.com  
**password:** test 

will give a succesful response. Any other credentials will return an error.


Here are some specific requirements our iOS developer got before creating this screen:

- Login button should only be enabled if both input fields are non-empty.
- The logged-in-state should be visualised as the title of the login button
  - Before even trying to log in the button should say "Log In"
  - While logging in it should say: "Logging In..."
  - After a successfull login the button should say: "Logged In OK"
- Logging in with bad credentials should show an alertView telling the user that the login failed. It should also change the title of the login button back to "Log In". 
- While logging in, both the input fields and the button should be disabled.


------

Your mission is to do the minimum steps required to setup Appium in this project and to write some automated UI tests for this Login screen. You should submit your work as a PR to this repository and write a short description as a pull request message on how to run the tests. You'll get extra points if you can also provide a small bash script that does most of the work and make it super easy for us to download any dependencies and run the tests. 


# theClocker
A vapor based time tracking server, part of the learner project.

Please also read the documents in our umbrella [learner-project](https://github.com/cocoaheads-slovenija/learner-project).

## Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use Vapor.

## Running the server

### Dependencies

The project needs the `sqlite3` development libraries for the local data storage.

On (Debian/Ubuntu) Linux this can be done with the command: `sudo apt install sqlite3`

On a mac the it can be installed using either [brew](http://brew.sh): `brew install sqlite3`,
or if you don't want to install HomeBrew on your mac (and you have the command line utilities from Xcode installed), by manually [downloading the sqlite sources](https://sqlite.org/download.html) (pick the "source code as an amalgamation" with the configure scripts), unpacking it on your computer, and running the following commands:

```shell
./configure --prefix=/usr/local/opt/sqlite
make
sudo make install
```

## Get to it already!

Install the [Vapor toolbox](https://vapor.github.io/documentation/getting-started/install-toolbox.html), and build the project with `vapor build`.

The server is run by running `vapor run serve`.

## Set up Facebook login

### Create a Facebook application

To get started, you first need to [register an application](https://developers.facebook.com/?advanced_app_create=true) with Facebook. After registering your app, go into your app dashboard's settings page. Add the Facebook Login product, and save the changes.

In the Valid OAuth redirect URIs box, type in your application's URL, postpended with `/login/facebook/consumer`. (eg, http://localhost:8080/login/facebook/consumer)

### **Add your Client ID / Secret as Environment Variables**

The code reads your Facebook client ID and secret from environment variables, and that mechanism is used on the server as well. Just set the following environment variables prior to running the code:

```shell
export FACEBOOK_CLIENT_ID="<your facebook app id>"
export FACEBOOK_CLIENT_SECRET="<your facebook app secret>"
```

This is also possible in Xcode under `Edit Scheme > Arguments > Environment Variables`.

#### Alternative

Setting the environment variables on macOS might not work under all circumstances. Creating a secrets file will.

Create the file `Config/secrets/app.json` (this directory is under `.gitignore` and should never be committed  to the repository), with the following content:

```json
{
	"facebookClientID": "<your facebook app id>",
	"facebookClientSecret": "<your facebook app secret>"
}
```

Now run the application. Facebook login should work!



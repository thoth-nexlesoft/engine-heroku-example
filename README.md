# Apollo Engine + Heroku
An example of how to use Engine as a Docker container to deploy to Heroku.  This guide assumes you already have a working Docker installation and have installed the Heroku CLI tools.

## Setup
First, clone the example repo.
```
git clone git@github.com:apollographql/engine-heroku-example.git
cd engine-heroku-example
```

Then edit the `config-template.json` file with the configuration specific to your environment.
Note that `origins.http.overrideRequestHeaders.Host` MUST also be set to the origin hostname so Heroku's virtual hosting system can properly route to the origin.  If you leave out this override, Engine proxy will end up in a circular connection loop and eventually crash.

Heroku requires support for runtime configuration of the port that Engine listens on.  This is exposed to the container via the $PORT environment variable.  This example includes a template script that allows you to rewrite the config when the container runs in a Heroku (or similar) environment.

It's also a good practice to set $API_KEY via the environment for security reasons, but you might prefer to hardcode it into this image as well.

## Deployment
Next, login to Heroku's container registry:
```
heroku container:login
```

Now you can build and push your image to Heroku.  In the boilerplate below, replace `<engine-app-name>` with the name of the Heroku app that you'd like to deploy into.  Note: you will need to create another app to run Engine that is separate from your origin GraphQL API app.

```
## build the image
docker build . -t registry.heroku.com/<engine-app-name>/web
```

Optional: run the container locally and test it out.  Using curl, you can send an introspection query to the origin server using your locally running Engine as a proxy.
```
## run the container
docker run -it --rm -e PORT=3000 -e API_KEY=<your-api-key> -p 3000:3000 registry.heroku.com/<engine-app-name>/web

## send an introspection query to port 3000 (mapped above)
curl -X POST -H 'Content-Type:application/json'  -d '{"query": "{__schema { queryType { name, fields { name, description} }}}"}' http://localhost:3000/graphql
```

Finally, we can now push the image to Heroku's container registery, which will deploy it to your app.
```
docker push registry.heroku.com/<engine-app-name>/web
```

If you've opted for dynamic configuration of the API_KEY, make sure to configure that in the environment area of the Heroku interface for this app.

That's it!

For further reading, explore the [official documentation](https://devcenter.heroku.com/articles/container-registry-and-runtime) on using containers inside Heroku.

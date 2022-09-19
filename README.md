# a reproducible Ruby on Rails application example for "[Failed to build with ruby27 builder](https://issuetracker.google.com/issues/244035704)" issue

## How to reproduce by deploying to App Engine Standard Environment

1. Set your `SECRET_KEY_BASE` in app.yaml
1. Run `gcloud app deploy`
1. Visit your deployed URL and you will get "We're sorry, but something went wrong."
1. You can find the following error in GAE application log
   ```
   ActionView::Template::Error (The asset "application.js" is not present in the asset pipeline.):
   6: <%= csrf_meta_tags %>
   7: <%= csp_meta_tag %>
   8:
   9: <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
   10: </head>
   11:
   12: <body>

   app/views/layouts/application.html.erb:9
   ```
1. You can find the following error in Cloud Build log
   ```
   Step #2 - "build": --------------------------------------------------------------------------------
   Step #2 - "build": Running "bundle exec ruby bin/rails assets:precompile (RAILS_ENV=production MALLOC_ARENA_MAX=2 RAILS_LOG_TO_STDOUT=true LANG=C.utf8)"
   Step #2 - "build": sh: 1: yarn: not found
   Step #2 - "build": rails aborted!
   Step #2 - "build": jsbundling-rails: Command build failed, ensure yarn is installed and `yarn build` runs without errors
   Step #2 - "build":
   Step #2 - "build": Tasks: TOP => assets:precompile => javascript:build
   Step #2 - "build": (See full trace by running task with --trace)
   Step #2 - "build": Done "bundle exec ruby bin/rails assets:precompile (RAILS_ENV=prod..." (1.234567890s)
   Step #2 - "build": WARNING: Asset precompilation returned non-zero exit code 1. Ignoring.
   ```

## How to reproduce by running Google CLoud Buildpacks ruby27 builder

1. Run Google Cloud Buildpacks ruby27 builder (`ruby27_20220831_2_7_6_RC00` is the latest at the time of writing)
   ```console
   pack build -v --builder us.gcr.io/gae-runtimes/buildpacks/ruby27/builder:ruby27_20220831_2_7_6_RC00 reproducible_example_google_issuetracker_244035704
   ```
1. You will find the following error in output
   ```
   [builder] === Ruby - Rails (google.ruby.rails@0.9.0) ===
   [builder] Running Rails asset precompilation
   [builder] --------------------------------------------------------------------------------
   [builder] Running "bundle exec ruby bin/rails assets:precompile (RAILS_ENV=production MALLOC_ARENA_MAX=2 RAILS_LOG_TO_STDOUT=true LANG=C.utf8)"
   [builder] sh: 1: yarn: not found
   [builder] rails aborted!
   [builder] jsbundling-rails: Command build failed, ensure yarn is installed and `yarn build` runs without errors
   [builder] 
   [builder] Tasks: TOP => assets:precompile => javascript:build
   [builder] (See full trace by running task with --trace)
   [builder] Done "bundle exec ruby bin/rails assets:precompile (RAILS_ENV=prod..." (874.392097ms)
   [builder] WARNING: Asset precompilation returned non-zero exit code 1. Ignoring.
   ```
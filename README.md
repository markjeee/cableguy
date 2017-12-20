## Overview

Compile configuration files based on a set of template and a database of config values.

## How to use

Add in your Gemfile.

```
gem 'cableguy'
```

Create a Cablefile.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

cabling do |cabler, cablefile, target|
  cabler.group = 'app'

  setup :template, 'database.yml'
  setup :dotenv
end
```

Create a template file, e.g.

config/templates/database.yml

```
default: &default
  adapter: mysql2
  host: '{database.host|127.0.0.1}'
  port: {database.port|3306}
  pool: {database.pool|5}
  username: '{database.username|root}'
  password: '{database.password}'
  encoding: utf8

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test

production:
  <<: *default
  database: app_production
```

Then run cable:

```
bundle exec cable
```

You should see something like:

```
ubuntu:user app$ bundle exec cable
== Configuring ~/work/app ==
  -- Loading configure data
  -- Setup template: database.yml
  -- Setup dotenv: .env.cableguy
== Configure done ==
```

There, a new file config/database.yml should be created based on the template file mentioned above.

To set some values, you may specify from a YAML file stored in your home directory.

~/.cabling_values.yml

```
# Top-level key matches the 'app' set in Cablefile.
# So you may have multiple apps defined in your cabling_values.yml
app:
  'database.host': '10.100.1.1'
  'database.port': '3306'
  'database.username': 'app-development'
  'database.password': 'super secret password'

another_app:
  'database.host': '10.100.1.2'
  'database.port': '3306'
  'database.username': 'another_app-development'
  'database.password': 'super secret password'
```

You may also specific cabling values per app, such as:

```
~/.cabling_values.app.yml
~/.cabling_values.another_app.yml
```

And the matching cabling_value file is loaded for that app.

## Dotenv support

If you want to specify some env variables, that will be loaded at runtime, you can specify them in the cabling_values.yml as:

```
app:
  .env: 
    'RAILS_MAX_THREADS': 3
```

And this will produce the following:

.env.cableguy

```
RAILS_MAX_THREADS="3"
_CABLEGUY_TARGET="development"
_CABLEGUY_LOCATION=""
```

And include this env file when loading Rails:

config/boot.rb

```
# load Cableguy generated dotenv if available.
require 'dotenv'
Dotenv.load('.env.cableguy')
```

## Capistrano support

Add in your Capfile:

```
require 'palmade/cableguy'
install_plugin Palmade::Cableguy::CapistranoTasks
```

## Templates

You can have as many template as you need in your app.

You can also have `target` specific templates, such as:

config/templates/database.production.yml

```
...

# DB name only set in production site
production:
  <<: *default
  database: app_actual_production_db
  
...
```

This template is used when cable is run with the specific target:

```
bundle exec cable --target=production
```

NOTE: Once you cabled a deployed app using one target (default target is `development`), you can't re-cable it, without un-locking the file.

**ERB support**

Each template, before parsing for values, is ERB evaluated, so you can add ruby logic in your template.

The ruby environment is very basic though, so don't expect your Rails environment to be around. And i wouldn't recommend trying to load it. You may load other files though, if Ruby can `require`, then it should be doable.

## About Targets

Targets can be any particular site where you want to deploy your app.

For example, you may have 'staging', 'alpha', 'europe', 'asia', 'singapore' as the different deployment sites you have for your app. This allows you to configure different templates for different sites.

**Why not use environment?**

This is a bit tricky, since you might want to use 'production' environment on all those site, but still want to use site specific configs. So you can use Cableguy for the specifics.

Also i like to think environments is always any of the following: 'development', 'test', and 'production'. These 3 have different behaviours for the app (the how). And the site is more of where (the where) you want to run the app using any of these environments.

**Why not just do this with Chef / Puppet / other provisioning systems**

That challenge with using outside the app config values is, those making the Chef/Puppet scripts needs to have inside knowledge of the config values, and what they mean. It is ok if the same people wrote the Chef scripts and the app. But once you want to scale that, you'll want to have a clear protocol on how to specific app values, without messing around its config files.

The solution here is just ask the Chef people to produce the .cabling_values.yml for each machine, and your app can take it from there.

**Surely, there must be capistrano for that**

I don't like the idea of having to go through SSH just to configure the app. What happen when i'm already in shell on the machine?

I like to think Capistrano is a deployment and remote invocation tool, and not try to micro-manage the app.

Cableguy has a capistrano hook to auto-cable itself right after deployment. So you may use it with Capistrano, and let Cableguy handle the configuration.

## How to contribute

Please fork, modify, test, and send a PR. If making a change, please add a test code, or update existing ones.

```
bundle
rake
```

## Origins

Cableguy started as an internal dev library at [Caresharing](https://caresharing.com). This is a fork from that, with a clean Git history.

CCC version, started with v0.5.0. All prior are still the internal versions.

While at Caresharing, originally authored by @poysama and @markjeee. For current contributors, please see this project's commit history.

## License

See [LICENSE.md](/LICENSE.md) file.

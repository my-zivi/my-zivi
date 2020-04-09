# MyZivi API

This is the backend of MyZivi. It's written in Ruby using Rails and functions only as a REST Api.

### Installation

To run the app, *Ruby 2.5.1* is required. You install ruby by using a version manager such as [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://github.com/asdf-vm/asdf).

To install the app run:

```bash
git clone git@github.com:orsa-scholis/myzivi.git
cd myzivi
bin/setup
```

A working version of mysql is required to run the setup.

## Running

To start the server, use `rails server` and navigate to [http://localhost:3000](http://localhost:3000).

To run the tests, use `bundle exec rspec` or `rake spec`.

To run all linting tools, use `bin/lint`. You can run only one of them by typing `bundle exec [linter]` e.g. `bundle exec rubocop`

Rubocop can also autofix all issues by using `bundle exec rubocop -a`

#### Seed Data

You can seed the database by running `rails db:seed` (should have been done automatically after running `bin/setup`).
This populates testing data into the development database.

Use the following accounts to log in:

| E-Mail                  | Password | Role                        |
| ----------------------- | -------- | --------------------------- |
| admin@example.com       | 123456   | Administrator               |
| zivi@example.com        | 123456   | Zivi                        |
| zivi_francise@france.ch | 123456   | Zivi (with french settings) |

If you want a freshly setup database, run

```bash
rails db:drop db:create db:setup

# If you made a migration, which is not known by db/schema.rb:
rails db:drop db:create db:migrate db:seed
```

## Development

The application is written with focus on 100% unit test coverage and relativly strict linting rules. For developing new features, having a 100% test coverage is required by the CI as well that all static code analysis tool pass (as well as all tests).

### Debugging

#### Breakpoints

If you're using an editor other than the JetBrains IDEs, you can write `debugger` anywhere in code where you want to interrupt. If the interpreter reaches this keyword, it stops and provides a console in the terminal where you started the rails server from.

Use `cont` or `next` to step through execution flow.

However, if you're using RubyMine or an equivalent JetBrains IDE, just set a normal breakpoint and install the missing gem.

#### Debug Prints

You can use the Ruby methods `p` or `pp` (which stands for pretty print) to print ruby objects to the console.

Make sure to remove them before pushing to the remote repository.

### Migrating from Old Version of MyZivi

To migrate the database of the old version, use the Rake task

```bash
bin/bundle exec rake v1_migration:import_legacy_data\[""\]
```

This loads the data from your dump file, saves it to a new migration db, converts the data to the new version and copies them to the currently selected Rails db.

After migrating the data, run `bin/bundle exec rake v1_migration:strip_iban` to strip all whitespaces of IBAN values.

## Deployment

The application gets automatically deployed to the corresponding environment, just by pushing to the reflecting branch on GitHub.

## Architecture

The API is a Ruby on Rails project built using the following gems:

| Gem                  | Description                                                                                                                                                                                                                                               |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| devise               | Authentication gem. It is used to to login users and to register new user. Furthermore, it can do password resets, confirmation, locking and much more. Documentation is available under https://github.com/plataformatec/devise                          |
| devise-jwt           | This gem enables JWT authentication using the devise gem. Documentation: https://github.com/waiting-for-dev/devise-jwt                                                                                                                                    |
| dotenv               | Used for loading environment variables while developing                                                                                                                                                                                                   |
| hexapdf              | PDF library which is currently only used for combining pdf files                                                                                                                                                                                          |
| iban-tools           | Validation and formatting of IBANs                                                                                                                                                                                                                        |
| jbuilder             | Tool for building JSON responses. It creates the "View" component of the app. <br/>The main reason we used this gem instead of serializing is to be consistent with the MVC pattern. However, the active record serialization gem would have been faster. |
| pdf-forms            | Fill pdf forms. Used for the service agreement                                                                                                                                                                                                            |
| prawn                | A gem to draw pdfs. Documentation: https://github.com/prawnpdf/prawn                                                                                                                                                                                      |
| prawn-table          | Table rendering gem for prawn                                                                                                                                                                                                                             |
| puma                 | Webserver used for development and production                                                                                                                                                                                                             |
| sepa_king            | Gem for building the PAIN payment file                                                                                                                                                                                                                    |
| validates_timeliness | ActiveModel validations for anything related to dates/time                                                                                                                                                                                                |
| brakeman             | Static security analysis tool                                                                                                                                                                                                                             |
| factory_bot_rails    | Gem to generate models and optionally save them to the testing database. Documentation: https://github.com/thoughtbot/factory_bot_rails                                                                                                                   |
| reek                 | Static code smell analyzer                                                                                                                                                                                                                                |
| rspec                | Testing library used to write all unit and request specs. Website: https://rspec.info/                                                                                                                                                                    |
| Rubocop              | Linting tool for ruby                                                                                                                                                                                                                                     |
| bullet               | Gem to prevent N+1 queries                                                                                                                                                                                                                                |
| letter_opener        | Development gem to enable email sending in browser (sent emails will be opened in your browser)                                                                                                                                                           |
| climate_control      | Modify environment variables during Specs                                                                                                                                                                                                                 |
| shoulda-matchers     | Gem with a lot of useful RSpec matchers. Documentation: https://github.com/thoughtbot/shoulda-matchers                                                                                                                                                    |
| simplecov            | Coverage analysis tool                                                                                                                                                                                                                                    |
| test-prof            | Analyze the efficiency of your specs and generate flamegraphs of db allocations                                                                                                                                                                           |

### Available Rake Tasks

Use `bundle exec rake [+ task]` to execute a task.

```ruby
rake about                                       # List versions of all Rails frameworks and the environment
rake active_storage:install                      # Copy over the migration needed to the application
rake app:template                                # Applies the template supplied by LOCATION=(/path/to/template) or URL
rake app:update                                  # Update configs and some other initially generated files (or use just update:configs or update:bin)
rake db:create                                   # Creates the database from DATABASE_URL or config/database.yml for the current RAILS_ENV (use db:create:all to create all databases in the config). Without RAILS_ENV or when RAILS_ENV is development, it defaults to creating the development and test databases
rake db:drop                                     # Drops the database from DATABASE_URL or config/database.yml for the current RAILS_ENV (use db:drop:all to drop all databases in the config). Without RAILS_ENV or when RAILS_ENV is development, it defaults to dropping the development and test databases
rake db:environment:set                          # Set the environment value for the database
rake db:fixtures:load                            # Loads fixtures into the current environment's database
rake db:migrate                                  # Migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)
rake db:migrate:status                           # Display status of migrations
rake db:prepare                                  # Runs setup if database does not exist, or runs migrations if it does
rake db:rollback                                 # Rolls the schema back to the previous version (specify steps w/ STEP=n)
rake db:schema:cache:clear                       # Clears a db/schema_cache.yml file
rake db:schema:cache:dump                        # Creates a db/schema_cache.yml file
rake db:schema:dump                              # Creates a db/schema.rb file that is portable against any DB supported by Active Record
rake db:schema:load                              # Loads a schema.rb file into the database
rake db:seed                                     # Loads the seed data from db/seeds.rb
rake db:seed:replant                             # Truncates tables of each database for current environment and loads the seeds
rake db:setup                                    # Creates the database, loads the schema, and initializes with the seed data (use db:reset to also drop the database first)
rake db:structure:dump                           # Dumps the database structure to db/structure.sql
rake db:structure:load                           # Recreates the databases from the structure.sql file
rake db:version                                  # Retrieves the current schema version number
rake feedback_mail:send                          # Sends a feedback reminder to all users who have completed a service lately
rake jwt:invalidate_all                          # Deletes all permitted JWT tokens
rake log:clear                                   # Truncates all/specified *.log files in log/ to zero bytes (specify which logs with LOGS=test,development)
rake middleware                                  # Prints out your Rack middleware stack
rake restart                                     # Restart app by touching tmp/restart.txt
rake secret                                      # Generate a cryptographically secure secret key (this is typically used to generate a secret for cookie sessions)
rake spec                                        # Run all specs in spec directory (excluding plugin specs)
rake spec:errors                                 # Run the code examples in spec/errors
rake spec:helpers                                # Run the code examples in spec/helpers
rake spec:i18n                                   # Run the code examples in spec/i18n
rake spec:mailers                                # Run the code examples in spec/mailers
rake spec:models                                 # Run the code examples in spec/models
rake spec:requests                               # Run the code examples in spec/requests
rake spec:routing                                # Run the code examples in spec/routing
rake spec:services                               # Run the code examples in spec/services
rake stats                                       # Report code statistics (KLOCs, etc) from the application or engine
rake time:zones[country_or_offset]               # List all time zones, list by two-letter country code (`rails time:zones[US]`), or list by UTC offset (`rails time:zones[-8]`)
rake tmp:clear                                   # Clear cache, socket and screenshot files from tmp/ (narrow w/ tmp:cache:clear, tmp:sockets:clear, tmp:screenshots:clear)
rake tmp:create                                  # Creates tmp directories for cache, sockets, and pids
rake v1_migration:import_legacy_data[dump_file]  # Migrates from legacy MyZivi data to new data format
rake v1_migration:strip_iban                     # Strips all whitespaces from the IBAN
rake zeitwerk:check                              # Checks project structure for Zeitwerk compatibility
```

The rake task `feedback_mail:send` is called by a cron job on monday 8:00 LCL to send all fedback reminder emails.

Cron jobs are configured in the Plesk interface and should not be configured manually.

### Available Routes

To list all routes, use `rails routes`. This prints a table of the URL, the generated rails helper method name and the arguments as well as the configured endpoint.

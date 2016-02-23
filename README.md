# Shaman

Cli for integrating with labs.infinum.co

## Installation

Install it yourself as:

    $ gem install shaman

## Usage

### Init

    $ shaman init

    Initialize your project

    Options:
      -f, --file FILE      Application file path
      -t, --token TOKEN    Environment token
      -u, --user EMAIL     Labs user email

Example of `.shaman.yml`

    ---
    :release_path: spec/files/test.ipa
    :environment_token: ZNkyGVgbnwMEU3L2Gx64o22h
    :deployer_email: stjepan.hadjic@infinum.hr

Explanation:

`release_path`      - this is the path to the release file
`environment_token` - This is a token you can find
[https://scr.infinum.co/stjepan_hadjic/Infinum_Labs_2016-02-23_17-14-08.png]
`deployer_email`    - This is an email you use with your git commits. You will also need to add this to your labs account.
[https://scr.infinum.co/stjepan_hadjic/Infinum_Labs_2016-02-23_17-16-52.png]

### Deploy

This will deploy your relese file to labs with with configs from .shaman.yml

    $ shaman deploy

    Options:
      -m, --message MESSAGE Changelog message
      -f, --file FILE      Release path
      -p, --proguard FILE  Add aditional proguard mapping
      -t, --token TOKEN    Use different environment token
      -c, --config FILE    Use different config file
      -d, --deployer EMAIL Labs deployer email
      -g, --git            Use git for deployer email and message (overrides any manual settings!)
      -C, --commit COMMIT  which commit to use instead of HEAD

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shaman. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


# cpomf

pomf backend written in crystal for pomf.is

## Installation

Set your environment variables:

`POMF_PORT` - The port that cpomf listens to.
`POMF_DEBUG` - Whether or not cpomf is in debug mode true|false
`POMF_DATABASE_URL` - The postgres URL for your database, eg; `postgres://localhost/pomf_database`
`POMF_SECRET_KEY` - Your secret key; preferably something that's long and randomly generated.
`POMF_ADMINS` - A comma seperated list of admin usernames; keeping in mind that usernames are lowercase and alphanumeric only.
`POMF_BLACKLISTED_NAMES` - A comma seperated list of banned usernames; it's usually good to blacklist names like admin or anything else you don't want users to use.
`POMF_UPLOAD_DIR` - Relative path to your pomf upload directory.
`POMF_UPLOAD_URL` - The upload URL for your site; eg. `https://u.pomf.is/`
```

Compile the project with `crystal build --release pomf.cr`

## Usage

Run cpomf like you would run any other binary file `./pomf`

Use a nginx reverse proxy to cpomf; and use nginx to handle static files, including those in /src/pomf/public; google tutorials if you need to.

Please make sure that you modify the default templates and styles before you host your own clone; I've left nya.is' designs in as a reference, but being unique is king in a sea of clones.


## Contributing

1. Fork it ( https://github.com/neko/cpomf/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [neko](https://github.com/neko) neko - creator, maintainer
- [RX14](https://github.com/RX14) RX14 - contributor

[![Build Status](https://travis-ci.org/steve-mcclellan/j-scorer.svg?branch=master)](https://travis-ci.org/steve-mcclellan/j-scorer)

The J! Scorer is a web app that makes it easy for prospective _Jeopardy!_
contestants to keep score along with the show, and track their training
progress via a bunch of different stats.

It is up and running on the web at <https://j-scorer.com>. Instructions for
users can be found [there][1], via the Help link.

See a sample stats page (and laugh at my actual stats!) [here][2].

### Screenshots

![Round in progress](screenshots/round_in_progress.png?raw=true)

![Stats by topic](screenshots/stats_topics.png?raw=true)

![Stats by row](screenshots/stats_by_row.png?raw=true)

![Final stats](screenshots/stats_final.png?raw=true)

![Final wagering thoughts](screenshots/stats_final_wagering.png?raw=true)

### Developer info

The J! Scorer uses the following custom environment variables:

| Variable | Description |
| -------- | ----------- |
| `SUPPORT_ADDRESS` | The contact email address to display within the app. |
| `SAMPLE_USER` | (_optional_) The id of the user whose stats should appear on the sample stats page. (`User.first`'s stats are used if this is absent.) |
| `SAMPLE_USER_EMAIL` | (_optional_) A string to display on the sample stats page instead of the sample user account's email. |
| `PROPER_DOMAIN` | (_production only, optional_) (e.g., `j-scorer.com`) If a request gets to the app from any other domain (or subdomain), redirect it to this one. |
| `MAILER_DOMAIN` | (_production only_) The value of `ActionMailer::Base.smtp_settings[:domain]`. (From the docs: "If you need to specify a HELO domain, you can do it here.") |
| `MAILER_HOST` | (_production only_) The value of `config.action_mailer.default_url_options[:host]`. This is the base url for generated links in emails. |

### Contributing

_**A plea**: If there's anyone out there with an eye for design who's willing and
able to help make the app look less ugly, without sacrificing usability, please
get in touch. I will love you forever._

Check out [the J! Scorer Main Project][3] to see what I'm working on and what
I'm planning to get to soon. Send me an email at the address below if you'd
like to beat me to something on that list. If you want to do something else
entirely, fantastic!

#### If you're an experienced open-source contributor

You know the drill. Fork, branch, pull request, ???, profit!.

#### If you're new to this sort of thing

* Check out [GitHub's documentation][4] for a good overview of the process.
* Get in touch with me at the address below. I love helping others do nifty
  stuff with code almost as much as I love doing it myself.

### Contact

If you need any help, drop me a line at <steve@j-scorer.com>.

[1]: https://j-scorer.com/help
[2]: https://j-scorer.com/sample
[3]: https://github.com/steve-mcclellan/j-scorer/projects/1
[4]: https://guides.github.com/activities/contributing-to-open-source

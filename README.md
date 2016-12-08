The J! Scorer is a web app for prospective _Jeopardy!_ contestants to track
their training progress.

It is up and running on the web at <https://j-scorer.com>. User documentation
can be found [there][1], via the Help link.

#### Developer info

The J! Scorer uses the following custom environment variables:

* SUPPORT_ADDRESS -> The contact email address to display on the app.
* SAMPLE_USER (optional) -> The id of the user whose stats should appear
  on the sample stats page. (User.first is used if this is absent.)
* SAMPLE_USER_EMAIL (optional) -> A string to display on the sample stats page
  instead of the sample user account's email.
* PROPER_DOMAIN (production only, optional) -> (e.g., j-scorer.com) If
  a request gets to the app from any other domain (or subdomain), redirect it
  to this one.
* MAILER_DOMAIN (production only) -> The value of
  ActionMailer::Base.smtp_settings[:domain]. (From the docs: "If you need to
  specify a HELO domain, you can do it here.")
* MAILER_HOST (production only) -> The value of
  config.action_mailer.default_url_options[:host]. This is the base url for generated
  links in emails.

Otherwise, this is a pretty-standard Rails 4 app. If you don't know what
to do with that, any decent tutorial should get you started.

If you need any further help, drop me a line at <steve@j-scorer.com>.

[1]: https://j-scorer.com/help

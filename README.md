# Discourse max-topics-per-month

This plugin adds a `max_topics_per_month` site setting. The limit applies to all non-staff members, just as the `max_topics_per_day` setting does.


## Tests with travis.

Pending.

## TODO 2021-03-15

I have a report that suggests that neither the `remaining_topics_this_month` value added to the serializer nor the front end code that uses it work as expected. Though I might fix this soon. I might not. Until that time, I recommend that `max_topics_per_month_enabled_ux` stays disabled.
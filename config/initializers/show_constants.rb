CURRENT_TOP_ROW_VALUES = [200, 400].freeze

PLAY_TYPES = {
  "regular"      => "regular play",
  "profs"        => "Professors Tournament",
  "toc"          => "Tournament of Champions",
  "teachers"     => "Teachers Tournament",
  "college"      => "College Championship",
  "goat"         => "Greatest of All Time",
  "teen"         => "Teen Tournament",
  "all-star"     => "Jeopardy! All-Star Games",
  "power"        => "Power Players Week",
  "celebrity"    => "Celebrity",
  "kids"         => "Kids Week / Back to School Week",
  "decades"      => "Battle of the Decades",
  "ibm"          => "The IBM Challenge",
  "mdci"         => "Million Dollar Celebrity Invitational",
  "kids-reunion" => "Kids Week Reunion",
  "utoc"         => "Ultimate Tournament of Champions",
  "mdm"          => "Million Dollar Masters",
  "intl"         => "International / Olympic",
  "armed"        => "Armed Forces Week",
  "teen-reunion" => "Teen Reunion Tournament",
  "senior"       => "Seniors Tournament",
  "tenth"        => "Tenth-Anniversary Tournament",
  "super"        => "Super Jeopardy!",
  "rock"         => "Rock & Roll Jeopardy!",
  "sports"       => "Sports Jeopardy!",
  "other"        => "other"
}.freeze

VALID_TYPE_INPUTS = (PLAY_TYPES.keys + ["all", "none"]).freeze

FILTER_FIELDS = [
  :show_date_reverse, :show_date_preposition, :show_date_beginning,
  :show_date_last_number, :show_date_last_unit, :show_date_from, :show_date_to,
  :date_played_reverse, :date_played_preposition, :date_played_beginning,
  :date_played_last_number, :date_played_last_unit, :date_played_from,
  :date_played_to, :rerun_status
].freeze

CURRENT_TOP_ROW_VALUES = [200, 400].freeze

PLAY_TYPES = {
  "regular"      => "regular play",
  "teachers"     => "Teachers Tournament",
  "college"      => "College Championship",
  "toc"          => "Tournament of Champions",
  "teen"         => "Teen Tournament",
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

module BackupsHelper
  include ERB::Util

  def parse_file(file)
    return nil if file.nil?
    verified_backup_input(JSON.parse(file.read, symbolize_names: true))
  rescue JSON::ParserError
    nil
  end

  private

  def verified_backup_input(i)
    return nil unless i.is_a?(Hash)
    games = i[:games_attributes]
    return nil unless games.is_a?(Array)
    games.each { |game| return nil unless validate_game(game) }
    games
  end

  def validate_game(game)
    return false unless game.is_a?(Hash)
    validate_game_info(game) && validate_sixths(game) && validate_final(game)
  end

  def validate_game_info(game)
    # These are the only inputs I can find that cause 500s.
    # Other bad input may mess up the stats, but who cares?
    return false unless game[:show_date].is_a?(String)
    return false if game[:round_one_score].nil?
    return false if game[:round_two_score].nil?
    true
  end

  def validate_sixths(game)
    sixths = game[:sixths_attributes]
    return false unless sixths.is_a?(Array) && sixths.length == 12

    sixths.each_with_index do |sixth, idx|
      return false unless sixth.is_a?(Hash)
      sixth[:title] = html_escape_once(sixth[:title])
      sixth[:type] = (idx < 6 ? 'RoundOneCategory' : 'RoundTwoCategory')
      sixth[:board_position] = (idx % 6) + 1
    end

    true
  end

  def validate_final(game)
    # The only situation that must be avoided here is a missing
    # final_attributes object/hash. This will cause a final-less
    # game to be created in the DB, which will yield a JS error
    # on the game page if the user tries to edit it.
    return false unless game[:final_attributes].is_a?(Hash)
    game[:final_attributes][:category_title] = html_escape_once(
      game[:final_attributes][:category_title])
    true
  end
end

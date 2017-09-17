module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'J! Scorer'
    page_title.blank? ? base_title : base_title + ' - ' + page_title
  end

  # rubocop:disable Rails/OutputSafety
  # These three methods never encounter user input. Repeatedly invoking Rails
  # helpers like content_tag, just to avoid calling html_safe, would
  # obfuscate the code with no obvious benefit.

  # Returns tags for descriptions, etc., on a per-page basis.
  def other_meta_tags(tags_string = '')
    tags_string.split('; ').map do |tag_string|
      name, content = tag_string.split(': ')
      "<meta name=\"#{name}\" content=\"#{content}\">"
    end.join("\n").html_safe
  end

  def random_partial_greeting
    ['Hello there', 'Greetings', 'Hi', 'Salutations', 'Hi there',
     'Howdy', 'Hey there', 'Welcome', 'Hello', 'Yo', '<i>¡Hola</i>',
     '<i>Salut</i>', '<i>Ciao</i>', '<i>Γεια</i>', '<i>Konnichiwa</i>',
     '<i>Salve</i>', '<i>Saluton</i>'].sample.html_safe
  end

  def random_full_greeting
    ['Hello there!', 'Greetings!', 'Hi!', 'Salutations!', 'Hi there!',
     'Howdy!', 'Hey there!', 'Welcome!', 'Hello!', 'Yo!', '<i>¡Hola!</i>',
     '<i>Salut!</i>', '<i>Ciao!</i>', '<i>Γεια!</i>', '<i>Konnichiwa!</i>',
     '<i>Salve!</i>', '<i>Saluton!</i>'].sample.html_safe
  end
  # rubocop:enable Rails/OutputSafety
end

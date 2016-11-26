module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'J! Scorer'
    page_title.blank? ? base_title : base_title + ' - ' + page_title
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
end

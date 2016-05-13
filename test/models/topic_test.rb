require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = Topic.create!(user: users(:dave), name: 'wordplay')
  end

  test 'should be valid' do
    assert @topic.valid?
  end

  test 'should require a user_id' do
    @topic.user_id = nil
    assert_not @topic.valid?
  end

  test 'should require a non-blank name' do
    @topic.name = nil
    assert_not @topic.valid?
    @topic.name = ''
    assert_not @topic.valid?
    @topic.name = '   '
    assert_not @topic.valid?
  end

  test 'topic name should be unique per user' do
    topic2 = Topic.new(user: users(:steve), name: 'WORDPLAY')
    assert topic2.valid?
    topic2.user = users(:dave)
    assert_not topic2.valid?
  end
end

require 'test_helper'

class CategoryTopicTest < ActiveSupport::TestCase
  def setup
    @cattop = CategoryTopic.create!(category: finals(:one),
                                    topic: topics(:one),
                                    placement: 1)
    @cattop2 = CategoryTopic.new(category: finals(:one),
                                 topic: topics(:two),
                                 placement: 2)
  end

  test 'should be valid' do
    assert @cattop.valid?
  end

  test 'should require a category_id' do
    @cattop.category_id = nil
    assert_not @cattop.valid?
  end

  test 'should require a category_type' do
    @cattop.category_type = nil
    assert_not @cattop.valid?
  end

  test 'should require a topic_id' do
    @cattop.topic_id = nil
    assert_not @cattop.valid?
  end

  test 'should require a non-negative placement value' do
    @cattop.placement = nil
    assert_not @cattop.valid?
    @cattop.placement = -3
    assert_not @cattop.valid?
    @cattop.placement = 0
    assert_not @cattop.valid?
  end

  test 'category and topic should belong to same user' do
    @cattop.topic = topics(:topic_of_steve)
    assert_not @cattop.valid?
  end

  test 'should be a unique combination of category and topic' do
    assert @cattop2.valid?
    @cattop2.topic = topics(:one)
    assert_not @cattop2.valid?
    @cattop2.category_type = 'RoundTwoCategory'
    assert @cattop2.valid?
  end

  test 'should have a unique placement within the category' do
    @cattop2.placement = 1
    assert_not @cattop2.valid?
  end
end

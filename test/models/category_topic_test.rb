require 'test_helper'

class CategoryTopicTest < ActiveSupport::TestCase
  def setup
    @cattop = CategoryTopic.new(category_id: 1,
                                category_type: 'Final',
                                topic_id: 1,
                                placement: 1)
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

  test 'should be a unique combination of category and topic' do
    # TODO
  end

  test 'should have a unique placement within the category' do
    # TODO
  end
end

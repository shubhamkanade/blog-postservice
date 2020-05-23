require 'test_helper'

class CommentTest < ActiveSupport::TestCase

    test "comments table exist" do
        assert ActiveRecord::Base.connection.table_exists? 'comments'
    end

    test "comments table has following columns" do
        ["user_id","post_id","comment"].each do |column|
            assert_includes(Comment.column_names, column)
        end
    end

    test "comment should not be empty" do
        my_comment = Comment.create(comment: '')
        assert my_comment.errors[:comment].include? "can't be blank"
    end

    test "user_id should not be empty" do
        user_id = Comment.create(user_id: '')
        assert user_id.errors[:user_id].include? "can't be blank"
    end

    test "post_id should not be empty" do
        post_id = Comment.create(post_id: '')
        assert post_id.errors[:post_id].include? "can't be blank"
    end

    context 'associations for comment model' do
        should belong_to(:post)
    end

    context 'associations for comment model' do
        should have_many(:claps)
    end
end
    
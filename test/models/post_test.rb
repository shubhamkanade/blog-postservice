require 'test_helper'

class PostTest < ActiveSupport::TestCase

    test "posts table exist" do
        assert ActiveRecord::Base.connection.table_exists? 'posts'
    end

    test "posts table has following columns" do
        ["user_id","title","description"].each do |column|
            assert_includes(Post.column_names,column)
        end
    end

    test "title should not be empty" do
        my_post = Post.create(title: '')
        assert my_post.errors[:title].include? "can't be blank"
    end

    test "description should not be empty" do
        my_post = Post.create(description: '')
        assert my_post.errors[:description].include? "can't be blank"
    end    

    test "user id should not be empty" do
        my_post = Post.create(user_id: '')
        assert my_post.errors[:user_id].include? "can't be blank"
    end

    context 'associations for post model' do
        should have_many(:comments)
    end

    context 'associations for post model' do
        should have_many(:claps)
    end
    
end
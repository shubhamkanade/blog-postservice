require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

    test "Should return created comment data" do

        post api_posts_path, params: {post: {title: "Post title", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: "this is a comment"}}
        assert_equal post_details['user_id'], JSON.parse(response.body)['comment']["user_id"]
        assert_equal post_details['id'], JSON.parse(response.body)["comment"]["post_id"]
        assert_equal "this is a comment", JSON.parse(response.body)["comment"]['comment']
        assert JSON.parse(response.body)["comment"]["id"]
        assert_equal 200, response.status

    end

    test "Should return error when comment cannot be created" do

        post api_posts_path, params: {post: {title: "Post title", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: ""}}
        assert_equal 422, response.status
        assert_includes JSON.parse(response.body)['errors']["comment"], "can't be blank"

    end

    test "should return all comments on a given post" do

        post api_posts_path, params: {post: {title: "Post title", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: "this is first comment"}}
        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: "this is second comment"}}
        get api_comments_path, params: {post_id: post_details['id']}
        assert_equal 2, JSON.parse(response.body)['comments'].count

    end

end
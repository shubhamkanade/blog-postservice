require 'test_helper'

class ClapsControllerTest < ActionDispatch::IntegrationTest

    test "a user claps on a post successfully" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_claps_path, params: {clap: {user_id: 2,clapable_id: post_details['id'],clapable_type: 'Post'}}
        assert_equal 200, response.status

    end

    test "Should return error when clap cannot be created" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_claps_path, params: {clap: {user_id: nil, clapable_id: post_details['id'], clapable_type: 'Post'}}
        assert_equal 422, response.status
        assert_includes JSON.parse(response.body)["user_id"], "can't be blank"

    end

    test "should return clap-count for a given post" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_claps_path, params: {clap: {user_id: 2, clapable_id: post_details['id'], clapable_type: 'Post'}}
        post api_claps_path, params: {clap: {user_id: 3, clapable_id: post_details['id'], clapable_type: 'Post'}}
        get api_claps_path, params: {clapable_id: post_details['id'], clapable_type: 'Post'}
        assert_equal 2, JSON.parse(response.body)['claps']

    end

    test "should return clap-count for a given comment" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: "this is first comment"}}
        comment_details = JSON.parse(response.body)['comment']
        post api_claps_path, params: {clap: {user_id: 2, clapable_id: comment_details['id'], clapable_type: 'Comment'}}
        post api_claps_path, params: {clap: {user_id: 3, clapable_id: comment_details['id'], clapable_type: 'Comment'}}
        get api_claps_path, params: {clapable_id: comment_details['id'], clapable_type: 'Comment'}
        assert_equal 2, JSON.parse(response.body)['claps']

    end

    test "user should not be able to clap on same post more than once" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']

        post api_claps_path, params: {clap: {user_id: 1,clapable_id: post_details["id"],clapable_type: 'Post'}}

        post api_claps_path, params: {clap: {user_id: 1,clapable_id: post_details["id"],clapable_type: 'Post'}}
        assert_equal "Cannot clap multiple times!", JSON.parse(response.body)["message"]
        assert_equal 405, response.status

    end

    test "user should not be able to clap on same comment more than once" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']

        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: "this is first comment"}}
        comment_details = JSON.parse(response.body)['comment']

        post api_claps_path, params: {clap: {user_id: 2, clapable_id: comment_details['id'], clapable_type: 'Comment'}}
        post api_claps_path, params: {clap: {user_id: 2, clapable_id: comment_details['id'], clapable_type: 'Comment'}}

        assert_equal "Cannot clap multiple times!", JSON.parse(response.body)["message"]
        assert_equal 405, response.status

    end

end
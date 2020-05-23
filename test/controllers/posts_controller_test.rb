require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

    test "Should return created post data" do

        post api_posts_path, params: {post: {title: "Post title", description: "Post desription", user_id: 1}}
        assert_equal "Post title", JSON.parse(response.body)["post"]["title"]
        assert_equal "Post desription", JSON.parse(response.body)["post"]["description"]
        assert_equal 1, JSON.parse(response.body)["post"]['user_id']
        assert JSON.parse(response.body)["post"]["id"]

    end

    test "Should return error when post cannot be created" do

        post api_posts_path, params: {post: {title: "Post title", description: "", user_id: 1}}
        assert_equal 422, response.status
        assert_includes JSON.parse(response.body)["description"], "can't be blank"

    end

    test "should return post details of particular id" do

        post api_posts_path, params: {post: {title: "Post title", description: "Post desription", user_id: 1}}
        post_id = JSON.parse(response.body)["post"]["id"]
        get api_post_path(post_id)
        assert_equal 200, response.status
        assert_equal post_id, JSON.parse(response.body)['post']['id']
        assert_equal "Post title", JSON.parse(response.body)['post']['title']
        assert_equal "Post desription", JSON.parse(response.body)['post']['description']
        assert_equal 1, JSON.parse(response.body)['post']['user_id']

    end

    test "should return post based on title" do

        post api_posts_path, params: { post: {title: "Post_1", description: "Post desription", user_id: 1}}
        post api_posts_path, params: { post: {title: "Post_2", description: "Post desription", user_id: 1}}
        get api_posts_path, params: {title: "Post_1"}
        assert_equal "Post_1", (JSON.parse(response.body)['posts'][0]['title'])

    end

    test "should not return post based on title for invalid title" do

        post api_posts_path, params: { post: {title: "Post_1", description: "Post desription", user_id: 1}}
        post api_posts_path, params: { post: {title: "Post_2", description: "Post desription", user_id: 1}}
        get api_posts_path, params: {title: "Sphinx"}
        assert_nil JSON.parse(response.body)['posts'][0]

    end

    test "should return count of posts found" do

        post api_posts_path, params: { post: {title: "Post_1", description: "Post desription", user_id: 1} }
        post api_posts_path, params: { post: {title: "Post_1", description: "Post desription", user_id: 1} }
        params = {title: "Post_1"}
        get api_posts_path(params)
        assert_equal 2, JSON.parse(response.body)['posts'].count

    end

    test "should destroy the given post" do

        post api_posts_path, params: { post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_id = JSON.parse(response.body)['post']['id']
        delete api_post_path post_id
        assert_equal "Successfully deleted!",JSON.parse(response.body)["message"]
        assert_equal 200, response.status

    end

    test "should update given post" do

        post api_posts_path, params: {post: {title: "Post title1", description: "Post desription", user_id: 1}}
        post_id = JSON.parse(response.body)['post']['id']
        patch api_post_path post_id, params: {post: {title: "Post title1", description: "Edited"}}
        assert_equal "Successfully edited!",JSON.parse(response.body)["message"]
        assert_equal 200, response.status

    end

    test "comments on a post should get deleted after that post is deleted" do

        post api_posts_path, params: {post: {title: "Post title", description: "Post desription", user_id: 1}}
        post_details = JSON.parse(response.body)['post']
        post api_comments_path , params: {comment: {user_id: post_details['user_id'], post_id: post_details['id'], comment: "this is a comment"}}
        comment_details = JSON.parse(response.body)['comment']
        delete api_post_path post_details["id"]
        refute Comment.exists?(comment_details['id'])

    end

    test "Should return all posts when searched field is empty" do
        post api_posts_path, params: { post: {title: "Post_1", description: "Post desription", user_id: 1}}
        post api_posts_path, params: { post: {title: "Post_2", description: "Post desription", user_id: 1}}
        get api_posts_path, params: {title: ""}
        assert_equal 2, JSON.parse(response.body)['posts'].count
    end

    test "Should return all posts when searched field is nil" do
        post api_posts_path, params: { post: {title: "Post_1", description: "Post desription", user_id: 1}}
        post api_posts_path, params: { post: {title: "Post_2", description: "Post desription", user_id: 1}}
        get api_posts_path, params: {title: nil}
        assert_equal 2, JSON.parse(response.body)['posts'].count
    end

end
require 'test_helper'

class ClapTest < ActiveSupport::TestCase

    test "claps table exist" do
        assert ActiveRecord::Base.connection.table_exists? 'claps'
    end

    test "clap table has following columns" do
        ["user_id","clapable_id","clapable_type"].each do |column|
            assert_includes(Clap.column_names,column)
        end
    end
    test "user id should not be empty" do
        my_clap = Clap.create(user_id: '')
        assert my_clap.errors[:user_id].include? "can't be blank"
    end
    test "clapable_id should not be empty" do
        my_clap = Clap.create(clapable_id: '')
        assert my_clap.errors[:clapable_id].include? "can't be blank"
    end
    test "clapable_type should not be empty" do
        my_clap = Clap.create(clapable_type: '')
        assert my_clap.errors[:clapable_type].include? "can't be blank"
    end

    context 'associations for clap model' do
        should belong_to(:clapable)
    end
end
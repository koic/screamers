# frozen-string-literal: true

require 'rails/generators/screamers/migration/migration_generator'

RSpec.describe Screamers::Generators::MigrationGenerator, type: :generator do
  destination File.expand_path('../../../../../../tmp', __FILE__)
  arguments ['integer', 'bigint']

  let(:generated_code) { <<-EOS.strip_heredoc
class ChangeIntegerToBigintUsingScreamers < ActiveRecord::Migration[5.1]
  def up
    change_column :comments, :id, :bigint
    change_column :comments, :post_id, :bigint

    change_column :posts, :id, :bigint
  end

  def down
    change_column :comments, :id, :integer
    change_column :comments, :post_id, :integer

    change_column :posts, :id, :integer
  end
end
    EOS
  }

  before(:all) do
    Timecop.travel(Time.parse('2017/06/26 14:13:00'))

    ActiveRecord::Base.establish_connection(adapter: :sqlite3, database: 'db/test.sqlite3')

    ActiveRecord::Schema.define do
      create_table :posts, force: true do |t|
        t.date :posted_at
      end

      create_table :comments, force: true do |t|
        t.integer :post_id
        t.date :commented_at
      end
    end

    class Post < ActiveRecord::Base
      has_many :comments
    end

    class Comment < ActiveRecord::Base
      belongs_to :post
    end

    prepare_destination
    run_generator
  end

  specify 'creates a active_record migration' do
    assert_file 'db/migrate/20170626141300_change_integer_to_bigint_using_screamers.rb', generated_code
  end

  after(:all) do
    Timecop.return
  end
end

class AddSecurityQuestionsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :security_question_id, :integer
    add_column :users, :security_answer_digest, :string
  end
end

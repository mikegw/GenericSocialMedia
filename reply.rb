class Reply < GenericSocialMedia
  # def self.find_by_id(id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         id = ?
#     SQL
#
#     results.map do |reply|
#       Reply.new(reply)
#     end
#   end
#
#   def self.find_by_question_id(question_id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         question_id = ?
#     SQL
#
#     results.map do |reply|
#       Reply.new(reply)
#     end
#   end
#
#   def self.find_by_user_id(user_id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         user_id = ?
#     SQL
#
#     results.map do |reply|
#       Reply.new(reply)
#     end
#   end

  attr_accessor :question_id, :parent_id, :user_id, :body
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    results.map do |reply|
      Reply.new(reply)
    end
  end
end
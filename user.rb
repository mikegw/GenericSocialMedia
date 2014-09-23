class User < GenericSocialMedia
  # def self.find_by_id(id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         id = ?
#     SQL
#
#     results.map do |user|
#       User.new(user)
#     end
#   end
#
#   def self.find_by_name(fname, lname)
#     results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         fname = ? AND lname = ?
#     SQL
#
#     results.map do |user|
#       User.new(user)
#     end
#   end

  attr_accessor :fname, :lname
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT
      COUNT(question_likes.id) /
        CAST(COUNT(DISTINCT(questions.id)) AS FLOAT) AS average_karma
    FROM
      questions
    LEFT OUTER JOIN question_likes
      ON questions.id = question_id
    WHERE
      questions.author_id = ?
    SQL
    result[0].values[0]
  end

end




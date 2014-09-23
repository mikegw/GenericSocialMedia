class QuestionLike < GenericSocialMedia
  # def self.find_by_id(id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         question_likes
#       WHERE
#         id = ?
#     SQL
#
#     results.map do |question_like|
#       QuestionLike.new(question_like)
#     end
#   end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes LEFT OUTER JOIN users
        ON user_id = users.id
      WHERE
        question_id = ?
    SQL

    results.map do |user|
      User.new(user)
    end
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(users.id)
      FROM
        question_likes LEFT OUTER JOIN users
        ON user_id = users.id
      WHERE
        question_id = ?
    SQL

    results[0].values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes LEFT OUTER JOIN questions
        ON question_id = questions.id
      WHERE
        user_id = ?
    SQL

    results.map do |question|
      Question.new(question)
    end
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.*
      FROM
        questions
        LEFT OUTER JOIN question_likes ON question_id=questions.id
      GROUP BY
        questions.id
      ORDER BY
      COUNT(question_likes.id) DESC
    SQL

    results.map! do |question|
      Question.new(question)
    end

    results.take(n)
  end

  attr_accessor :user_id, :question_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
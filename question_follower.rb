class QuestionFollower < GenericSocialMedia
  # def self.find_by_id(id)
 #    results = QuestionsDatabase.instance.execute(<<-SQL, id)
 #      SELECT
 #        *
 #      FROM
 #        question_followers
 #      WHERE
 #        id = ?
 #    SQL
 #
 #    results.map do |question_follower|
 #      QuestionFollower.new(question_follower)
 #    end
 #  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_followers
        LEFT OUTER JOIN users ON user_id=users.id
      WHERE
        question_followers.question_id = ?
    SQL

    results.map do |user|
      User.new(user)
    end
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_followers
        LEFT OUTER JOIN questions ON question_id=questions.id
      WHERE
        question_followers.user_id = ?
    SQL

    results.map do |question|
      Question.new(question)
    end
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.*
      FROM
        questions
        LEFT OUTER JOIN question_followers ON question_id=questions.id
      GROUP BY
        questions.id
      ORDER BY
      COUNT(question_followers.id) DESC
    SQL

    results.map! do |question|
      Question.new(question)
    end

    results.take(n)
  end

  attr_accessor :question_id, :user_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
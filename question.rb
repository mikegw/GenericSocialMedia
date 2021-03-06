class Question < GenericSocialMedia
  # def self.find_by_id(id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         questions
#       WHERE
#         id = ?
#     SQL
#
#     results.map do |question|
#       Question.new(question)
#     end
#   end
#
#   def self.find_by_author_id(author_id)
#     results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
#       SELECT
#         *
#       FROM
#         questions
#       WHERE
#         author_id
#          = ?
#     SQL
#
#     results.map do |question|
#       Question.new(question)
#     end
#   end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionFollower.most_liked_questions(n)
  end

  attr_accessor :title, :body, :author_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    results = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    results.map do |user|
      User.new(user)
    end
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollower.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

end
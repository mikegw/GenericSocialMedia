class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class GenericSocialMedia

  # Saving Methods

  def self.table_name
    self.name.downcase + 's'
  end

  def save
    self.id.nil? ? create : update
    nil
  end

  def create
    QuestionsDatabase.instance.execute(<<-SQL, *col_vals[1..-1])
      INSERT INTO
        #{table_name} (#{col_names[1..-1].join(", ")})
      VALUES
        (#{Array.new(col_names.length - 1, "?").join(", ")})
    SQL
    puts "Saved!"
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, *col_vals[1..-1], col_vals[0])
      UPDATE
        #{table_name}
      SET
        #{col_names[1..-1].join(" = ?, ")} = ?
      WHERE
        id = ?
    SQL
  end

  def col_names
    col_names = self.instance_variables
    col_names.map! { |col_name| col_name.to_s[1..-1]}
  end

  def col_vals
    col_names.map { |col_name| self.method(col_name.to_sym).call }
  end

  # Generic finding methods

  def self.method_missing(*args)
    method_called = args[0].to_s
    if method_called[0..6] == 'find_by'
      col = method_called[8..-1]
      self.find_by_col(col, *args.drop(1))
    else
      raise NoMethodError
    end
  end

  def self.find_by_col(*args)
    col_name = args[0]
    col_val = args[1].to_s

    results = QuestionsDatabase.instance.execute(<<-SQL, col_val)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{col_name} = ?
    SQL

    results.map do |row|
      self.new(row)
    end
  end
end
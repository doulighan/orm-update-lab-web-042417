require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
 
  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.create_table
    sql = "CREATE TABLE students
    (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    self.update
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.new_from_db(array)
    self.new(array[0], array[1], array[2])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end





end

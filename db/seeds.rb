# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SUBJECTS = {
  'Other' => 'Other',
  'CSC200' => 'Intro to Computer Science',
  'CSC201' => 'Computer Science I',
  'CSC202' => 'Computer Science II',
  'CSC205' => 'Computer Organization',
  'ENG111' => 'English Composition I',
  'ENG112' => 'English Composition II',
  'MTH173' => 'Calculus with Analytical Geometry I',
  'MTH174' => 'Calculus with Analytical Geometry II',
  #....
}

SUBJECTS.each do |number, name|
  Subject.create(course_number: number, course_name: name)  
end

USERS = [
  {
    username: 'Alice',
    email: 'alice@example.com',
    password: 'password',
    password_confirmation: 'password',
  },
  {
    username: 'Bob',
    email: 'bob@example.com',
    password: 'password',
    password_confirmation: 'password',
  },
  {
    username: 'Carol',
    email: 'carol@example.com',
    password: 'password',
    password_confirmation: 'password',
  },
  {
    username: 'Dave',
    email: 'dave@example.com',
    password: 'password',
    password_confirmation: 'password',
  },
  {
    username: 'Eve',
    email: 'eve@example.com',
    password: 'password',
    password_confirmation: 'password',
  },
]

User.create(USERS)

alice = User.find_by_email('alice@example.com')
bob = User.find_by_email('bob@example.com')

alice.create_tutor({ 
  subjects: [
      Subject.find_by_course_number('CSC200'),
      Subject.find_by_course_number('CSC201'),
      Subject.find_by_course_number('CSC202'),
      Subject.find_by_course_number('CSC205'),
      Subject.find_by_course_number('MTH173'),
      Subject.find_by_course_number('MTH174'),
    ]
  })

bob.create_tutor({ 
  subjects: [
      Subject.find_by_course_number('ENG111'),
      Subject.find_by_course_number('ENG112'),
      Subject.find_by_course_number('MTH173'),
    ]
  })


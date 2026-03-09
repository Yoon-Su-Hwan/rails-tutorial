# inheritence feature of ruby
# Post class is a child class of ApplicationRecord class
# ApplicationRecord class is a child class of ActiveRecord::Base class
# ActiveRecord의 기능을 사용하기 위해서는 ApplicationRecord를 상속받아야한다
# applicationRecord은 ActiveRecord::Base를 상속받아서 만들어진 클래스이다
# ActiveRecord::Base는 Ruby on Rails에서 제공하는 ORM(Object-Relational Mapping) 라이브러리인 ActiveRecord의 기본 클래스입니다. ActiveRecord는 데이터베이스와 상호 작용하기 위한 인터페이스를 제공하며, 모델 클래스가 이 기능을 활용할 수 있도록 합니다.
# Post 모델은 ApplicationRecord를 상속받아서 만들어진 클래스입니다.
#  따라서 Post 모델은 ActiveRecord의 기능을 사용할 수 있습니다.
#  예를 들어, Post 모델을 사용하여 데이터베이스에
#   레코드를 생성, 조회, 업데이트, 삭제할 수 있습니다.
#    ActiveRecord는 이러한 작업을 간단하게 수행할 수 있도록 메서드를 제공합니다.
#    예를 들어, Post.create(title: "Hello World", body: "This is my first post")와 같이
#   레코드를 생성할 수 있습니다.
class Post < ApplicationRecord
  belongs_to :user

  # Validation, Title Length, or it has no existence
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }
end

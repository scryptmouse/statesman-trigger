class Article < ActiveRecord::Base
  has_many :article_transitions
end

class ArticleTransition < ActiveRecord::Base
  belongs_to :article
end

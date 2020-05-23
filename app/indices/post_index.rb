ThinkingSphinx::Index.define :post, with: :real_time do

  indexes title
  indexes description
  set_property :min_prefix_len => true

end
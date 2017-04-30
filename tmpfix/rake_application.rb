# frozen_string_literal: true

# Remove this file together with its require statements  as soon as
# YARD::Rake::YardocTask stops depending on last_comment.
# last_comment has been removed in Rake 11.
module TempFixForRakeLastComment
  # Track the last comment made in the Rakefile.
  def last_comment
    last_description
  end
end

Rake::Application.send :include, TempFixForRakeLastComment

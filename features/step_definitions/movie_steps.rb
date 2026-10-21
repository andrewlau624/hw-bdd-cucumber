Given(/the following movies exist/) do |movies_table|
  Movie.delete_all
  movies_table.hashes.each { |movie| Movie.create!(movie) }
end

Then(/(.*) seed movies should exist/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

Then(/^I should see "(.*)" before "(.*)" in the movie list$/) do |e1, e2|
  expect(page.body).to match(/#{Regexp.escape(e1)}.*#{Regexp.escape(e2)}/m)
end

When(/I check the following ratings: (.*)/) do |rating_list|
  ratings = rating_list.split(',').map(&:strip)
  Movie.all_ratings.each { |rating| find("#ratings_#{rating}").set(ratings.include?(rating)) }
end

Then(/^I should (not )?see the following movies:$/) do |no, movies_table|
  movies_table.hashes.each do |movie|
    no ? expect(page).not_to(have_content(movie['title'])) : expect(page).to(have_content(movie['title']))
  end
end

Then(/^I should see all the movies$/) do
  expect(page).to have_css('#movies > div', count: Movie.count)
end
